# Déploiement pas à pas d'un site Lutece sur Kubernetes — plusieurs réplicas

Ce guide détaille la construction et le déploiement du site de la branche `multi-instance` : un site Lutece 8 (socle
Forms) sur Open Liberty, en plusieurs réplicas qui partagent la session HTTP et le cache Lutece par Hazelcast, une base
MariaDB et l'observabilité Grafana OTel LGTM, sur minikube.

Les chapitres communs avec une seule instance (pom, configuration Open Liberty, conteneurisation, MariaDB, profils,
observabilité) sont repris de la branche `mono-instance` ; ce guide détaille ce qui change avec plusieurs réplicas.

# Table des matières

- [Prérequis](#prérequis)
- [1. Ce que demandent plusieurs réplicas](#1-ce-que-demandent-plusieurs-réplicas)
- [2. Le site Lutece](#2-le-site-lutece)
  - [2.1. Le pom : profils cluster et local](#21-le-pom--profils-cluster-et-local)
  - [2.2. server.xml et cluster.xml](#22-serverxml-et-clusterxml)
  - [2.3. Le membre Hazelcast](#23-le-membre-hazelcast)
  - [2.4. Le client Hazelcast du cache Lutece](#24-le-client-hazelcast-du-cache-lutece)
  - [2.5. jvm.options](#25-jvmoptions)
  - [2.6. La configuration Lutece](#26-la-configuration-lutece)
  - [2.7. Lancer le site en local](#27-lancer-le-site-en-local)
- [3. Conteneurisation](#3-conteneurisation)
- [4. Déploiement sur Kubernetes](#4-déploiement-sur-kubernetes)
  - [4.1. MariaDB](#41-mariadb)
  - [4.2. Ressources communes](#42-ressources-communes)
  - [4.3. Migrations Liquibase](#43-migrations-liquibase)
  - [4.4. Les réplicas](#44-les-réplicas)
  - [4.5. L'ingress](#45-lingress)
  - [4.6. Vérifier le cluster](#46-vérifier-le-cluster)
  - [4.7. Mise à jour](#47-mise-à-jour)
- [5. Observabilité](#5-observabilité)
- [6. Démontage de l'environnement](#6-démontage-de-lenvironnement)
- [Documentation](#documentation)

## Prérequis

1. Java 21 et Maven 3.9 ou plus.
2. Git.
3. Docker ([documentation](https://docs.docker.com/install/)) ou Podman.
4. Minikube ([documentation](https://minikube.sigs.k8s.io/docs/start/)), démarré avec au moins 6 CPU et 8 Go pour deux
   réplicas, MariaDB et LGTM : `minikube start --cpus 6 --memory 8g`.
5. kubectl ([documentation](https://kubernetes.io/docs/tasks/tools/)).

```sh
git clone -b multi-instance https://github.com/lutece-platform/lutece-guide-kubernetes-lutece.git
cd lutece-guide-kubernetes-lutece
```

# 1. Ce que demandent plusieurs réplicas

Derrière un répartiteur sans affinité, deux requêtes d'un même usager arrivent sur deux pods différents. Tout ce qu'un
pod garde en mémoire doit donc être partagé ou rester propre au pod :

| État | Une instance | Plusieurs réplicas |
|---|---|---|
| Session HTTP | mémoire de la JVM | Hazelcast (`sessionCache-1.0` d'Open Liberty) |
| Cache Lutece (JCache) | Ehcache, dans la JVM | Hazelcast, avec un near cache dans chaque pod |
| Daemons | un exécuteur par JVM | Quartz en cluster : un daemon exclusif ne tourne que sur un réplica |
| Schéma de la base | Liquibase au démarrage | Liquibase depuis un seul pod, avant les réplicas |
| Index Lucene de Forms | disque du pod | volume ReadWriteMany partagé |

Le code des plugins doit le supporter : état dans la base, la session ou le cache Lutece (jamais dans un champ
statique), objets de session et de cache sérialisables. Les plugins du BOM de la plateforme Lutece 8.0.0-beta-04 et
suivantes sont corrigés pour cela. Un plugin développé hors de la plateforme doit être vérifié avant de passer un site en
plusieurs réplicas ; s'il ne le supporte pas, le site reste en une instance.

# 2. Le site Lutece

## 2.1. Le pom : profils cluster et local

Dépendances (versions données par le BOM `lutece-bom`, propriété `lutece-platform.version`) :

- `forms-starter` : core, forms, genericattributes, workflow et leurs modules ;
- `plugin-health` : vérification de la base par la sonde `/health/ready` ;
- `plugin-quartz-scheduler` : remplace l'exécuteur de daemons du core par Quartz, en cluster.

Profil **`cluster`**, actif par défaut (activé par l'absence de la propriété `local`, pour rester actif avec
`-Pcontainer-runtime`) :

```xml
<dependency>  <!-- membre et client Hazelcast, dans le war -->
    <groupId>com.hazelcast</groupId>
    <artifactId>hazelcast</artifactId>
    <version>5.7.2</version>
    <scope>runtime</scope>
</dependency>
<dependency>  <!-- taille des caches Lutece sous Hazelcast -->
    <groupId>fr.paris.lutece.plugins</groupId>
    <artifactId>library-cache-hazelcast</artifactId>
    <type>jar</type>
</dependency>
<dependency>  <!-- Ehcache retiré du war -->
    <groupId>org.ehcache</groupId>
    <artifactId>ehcache</artifactId>
    <version>3.12.0</version>
    <classifier>jakarta</classifier>
    <scope>provided</scope>
</dependency>
```

Hazelcast 5.7.1 et suivantes ne sont publiées que sur le dépôt Hazelcast (déclaré dans le pom) : Maven Central s'arrête
à 5.7.0.

JCache ne transmet pas la taille d'un cache : sans `library-cache-hazelcast`, tous les caches Lutece sont limités à
10 000 entrées sous Hazelcast, quelle que soit leur taille Lutece. La bibliothèque applique `maxElementsInMemory` de
chaque cache à sa création dans le cluster.

Profil **`local`** (`-Dlocal`) : le site tourne en une instance avec Ehcache, sans Hazelcast (chapitre 2.7).

## 2.2. server.xml et cluster.xml

`server.xml` reprend la configuration de la branche `mono-instance` (pool de threads borné, connexions persistantes,
adresse du client, source de données) et inclut `cluster.xml` :

```xml
<variable name="cluster.config" defaultValue="cluster.xml" />
<include location="${server.config.dir}/${cluster.config}" optional="true" />
```

Le profil `local` écrit `cluster.config=aucun.xml` dans `bootstrap.properties` : le fichier n'existe pas, l'inclusion
optionnelle est ignorée. La valeur doit venir de `bootstrap.properties` : une variable de `configDropins` n'est pas lue
pour un `include`.

Pool de connexions : 12 par pod. La limite de connexions de l'utilisateur de la base doit couvrir
(réplicas + pod de surplus du redémarrage progressif + pod de migration) x 12.

`cluster.xml` :

```xml
<featureManager>
    <feature>sessionCache-1.0</feature>
</featureManager>

<library id="hazelcastSessionLib">
    <fileset dir="/config/apps/expanded/lutece.war/WEB-INF/lib/" includes="*.jar" />
</library>
<httpSessionCache libraryRef="hazelcastSessionLib" writeContents="GET_AND_SET_ATTRIBUTES"
                  uri="file:${server.config.dir}/hazelcast-config-api-mode.yaml" />

<variable name="lutece.cache.jcache.cachingprovider" value="com.hazelcast.client.cache.HazelcastClientCachingProvider" />
<variable name="lutece.cache.jcache.config.uri" value="file:${server.config.dir}/hazelcast-client-config-api-mode.yaml" />
```

- **`sessionCache-1.0`** démarre un membre Hazelcast dans chaque pod et y range les sessions HTTP.
- **Bibliothèque de session = tous les jars du war**, pas seulement `hazelcast*.jar`. Le client du cache Lutece se
  connecte au membre de son pod : ce membre héberge donc aussi les caches Lutece, dont la configuration porte des
  classes Lutece. Pour migrer ses partitions quand un pod s'arrête ou arrive, il doit résoudre ces classes ; avec le seul
  jar Hazelcast : `Could not resolve type`, rééquilibrage abandonné, sessions perdues au redémarrage progressif. Le war
  est déployé décompressé par `configure.sh` (Dockerfile).
- **`writeContents="GET_AND_SET_ATTRIBUTES"`** : la valeur par défaut ne réplique que les `setAttribute`. Les beans
  `@SessionScoped` modifiés en place (formulaires en plusieurs étapes) seraient perdus au changement de pod, alors que la
  connexion au back office continue de fonctionner.
- **Cache Lutece** : provider client Hazelcast. Une `<variable>` avec `value=` est une source MicroProfile Config
  d'ordinal 500, au-dessus de `conf/override`.

## 2.3. Le membre Hazelcast

`hazelcast-config-api-mode.yaml` :

| Réglage | Pourquoi |
|---|---|
| `cluster-name: lutece-guide` | Deux sites d'un même namespace ne fusionnent pas leurs clusters |
| `hazelcast.shutdownhook.policy: GRACEFUL`, `hazelcast.graceful.shutdown.max.wait: 45` | À l'arrêt du pod, le membre transfère ses partitions (sessions) aux autres avant de partir |
| `hazelcast.shutdownhook.enabled: false` | Le hook JVM fermait le membre pendant qu'Open Liberty servait encore des requêtes : erreurs 500 au redémarrage progressif. Open Liberty ferme le membre en arrêtant `sessionCache-1.0` |
| `hazelcast.cache.invalidation.batch.enabled: false` | Invalidations des near caches envoyées tout de suite, pas par lots de plusieurs secondes |
| port 5701 fixe | Le Service Kubernetes et le client du cache l'attendent |
| `join.kubernetes`, `service-name: ${hz.service-name}` | Les membres se trouvent par l'API Kubernetes |

Aucune section `cache:` : durée de vie et taille de chaque cache viennent de Lutece. Ne jamais déclarer `"*"` : l'entrée
s'applique aussi aux caches de session d'Open Liberty, et un cluster démarré de zéro ne démarre plus (`SESN0307E
Incompatible cache key types`). Un redémarrage progressif le cache : les membres en marche gardent les caches de session
déjà créés.

## 2.4. Le client Hazelcast du cache Lutece

`hazelcast-client-config-api-mode.yaml` : le client se connecte au membre de son pod (`127.0.0.1:5701`), puis découvre
les autres membres par la topologie du cluster.

Le **near cache** garde dans le pod une copie des entrées lues, invalidée à chaque modification. Sans lui, chaque
lecture du cache est un appel réseau : 2,2 requêtes/s contre 37 mesurées.

| Cache | `in-memory-format` | Pourquoi |
|---|---|---|
| `formsCacheService` | `BINARY` | Forms modifie les objets qu'il lit dans son cache (listes de questions, d'étapes) : chaque lecture doit rendre une copie, comme avec Ehcache. En `OBJECT`, deux affichages simultanés de la multivue trient la même liste (`ConcurrentModificationException`). Coût : environ 5 % de CPU |
| tous les autres (`"*"`) | `OBJECT` | Pas de copie à la lecture ; `BINARY` coûte un tiers de CPU en plus |

`time-to-live-seconds: 600` : une expiration ou une éviction côté membre n'invalide pas le near cache ; sa durée de vie
reste sous celle des caches Lutece (3600 s par défaut). Une donnée modifiée hors de Lutece reste ainsi en cache au plus
3600 + 600 s.

Le routage du client reste à sa valeur par défaut (`ALL_MEMBERS`) : `SINGLE_MEMBER` a donné 12 % de débit en moins.

## 2.5. jvm.options

```
-Dhazelcast.jcache.provider.type=member
-Dhz.service-name=lutece-guide-hazelcast
--add-modules=java.se
--add-exports=java.base/jdk.internal.ref=ALL-UNNAMED
...
-XX:+ExitOnOutOfMemoryError
```

- `hazelcast.jcache.provider.type=member` : le provider JCache chargé par `sessionCache-1.0` démarre en membre. Sans
  elle, il démarre en client et il n'y a pas de membre.
- `hz.service-name` : nom du Service Kubernetes de découverte ; surchargeable par `JVM_ARGS="-Dhz.service-name=..."`.
- `--add-opens` / `--add-exports` : accès de Hazelcast aux API internes de Java (sinon avertissement et performances
  dégradées) ; la dernière ligne est propre à OpenJ9.

## 2.6. La configuration Lutece

`webapp/WEB-INF/conf/override/profiles-config.properties`, en plus de la branche `mono-instance` :

**Liquibase** : `liquibase.enabled.at.startup=true` sert au démarrage local. Les réplicas démarrent avec
`-Dliquibase.enabled.at.startup=false` (une propriété système l'emporte sur ce fichier) ; les migrations passent par un
pod dédié (chapitre 4.3).

**Index Lucene de Forms** sur le volume partagé : `forms.internalIndexer.lucene.indexInWebapp=false`, chemin donné par
`JVM_ARGS` du déploiement. Le contrôle d'accès du back office à une réponse cherche dans cet index : avec un index par
pod, le détail d'une réponse affiche « accès refusé » dès que la requête change de pod.
`forms.index.writer.ms.timeout.lock=120000` : un pod arrêté sans rendre le verrou d'écriture ne bloque l'indexation que
2 min (15 par défaut).

**Daemons** :

```properties
quartzscheduler.cluster.enable=true
quartzscheduler.daemon.mailSender.disallowedClusterConcurrentExecution=true
...
```

`plugin-quartz-scheduler` livre `quartzscheduler.cluster.enable=false` : sans cette ligne, aucun planificateur en
cluster ne démarre et les daemons déclarés exclusifs tournent quand même sur chaque réplica. Sont exclusifs les daemons
qui agissent sur un état partagé (base, mails, workflow, index partagé, purges) : un daemon de workflow exécuté deux fois
répète ses tâches. Restent sur chaque réplica `indexer` (index de recherche du core, propre à chaque pod) et
`threadLauncherDaemon` (file de tâches en mémoire du pod).

Un `<daemon-id>` faux est ignoré sans erreur. Les identifiants du war :

```sh
grep -ho "<daemon-id>[^<]*" target/lutece-guide-kubernetes-*/WEB-INF/conf/core.xml target/lutece-guide-kubernetes-*/WEB-INF/plugins/*.xml
```

**Cache** : une donnée modifiée hors de Lutece (script SQL, restauration) reste en cache, même après un redémarrage
progressif (le cluster survit tant qu'un pod reste en marche). Vider les caches depuis le back office (gestion des
caches) : l'action vaut pour tout le cluster. Activer ou désactiver un cache depuis le back office s'applique aux autres
réplicas en 30 s (`lutece.cache.status.refreshSeconds`).

**`webapp/WEB-INF/plugins/plugins.dat`** : sur une base neuve, seuls les plugins listés sont installés ;
`plugin-quartz-scheduler` y figure, ses tables `qrtz_*` sont créées par Liquibase.

## 2.7. Lancer le site en local

```sh
mariadb -u root -p < deploy/sql/init.sql
mvn liberty:run -Dlocal
```

`init.sql` ne crée que la base `core`. Le site s'y connecte avec l'utilisateur des variables `portal.user` et
`portal.password` de `server.xml` (`lutece` / `some_password` par défaut), à créer avec ses droits sur `core`, ou à
remplacer au lancement : `-Dliberty.var.portal.user=... -Dliberty.var.portal.password=...`.

Une instance, Ehcache, pas de Hazelcast : `http://localhost:9090/lutece/`.

# 3. Conteneurisation

```sh
mvn clean lutece:site-assembly -Pcontainer-runtime
eval $(minikube docker-env)
docker build -t lutece-guide-kubernetes:multi-1.0.0-SNAPSHOT .
```

Avec Podman : `podman build ...`, puis `minikube image load lutece-guide-kubernetes:multi-1.0.0-SNAPSHOT`.

Hazelcast est dans le war (profil `cluster`) : l'image n'a pas besoin d'un jar Hazelcast séparé. `configure.sh` déploie
le war dans `/config/apps/expanded`, où `cluster.xml` lit la bibliothèque de session.

# 4. Déploiement sur Kubernetes

## 4.1. MariaDB

```sh
kubectl apply -f deploy/k8s/mariadb-manifest.yaml
kubectl rollout status deployment/mariadb
```

Comme pour une instance : MariaDB 11.8 en UTC (comme les pods Lutece), base `core` et utilisateur `lutece` créés par
l'image, 512 Mi demandés et 1 Gi au maximum. Le fuseau compte davantage avec plusieurs réplicas : tous les pods et la
base doivent avoir le même.

## 4.2. Ressources communes

```sh
kubectl apply -f deploy/k8s/lutece-base.yaml
```

| Ressource | Rôle |
|---|---|
| Secret `db-credentials`, ConfigMap `lutece-config` | Identifiants de la base, profil MicroProfile Config |
| ServiceAccount `lutece`, Role et RoleBinding `lutece-hazelcast` | Lecture des pods, endpoints et services du namespace, pour la découverte des membres |
| Service `lutece-guide-hazelcast` (headless, port 5701) | Nom donné à `hz.service-name` |
| PersistentVolumeClaim `lutece-lucene` (ReadWriteMany) | Index Forms partagé. Sur un vrai cluster, une classe de stockage ReadWriteMany (NFS, CephFS...) ; le provisionneur de minikube l'accepte |
| Service `lutece-service` (NodePort 31000) | Accès au site, cible de l'ingress |

## 4.3. Migrations Liquibase

Deux réplicas qui migrent la même base en même temps se bloquent ou se corrompent : les migrations passent par un pod
unique, avant les réplicas.

```sh
kubectl apply -f deploy/k8s/lutece-migration.yaml
kubectl rollout status deployment/lutece-liquibase --timeout=10m   # prêt = migrations faites
kubectl delete -f deploy/k8s/lutece-migration.yaml
```

Le pod de migration a son propre label (aucun Service ne lui envoie de trafic) et son propre nom de service Hazelcast
(il ne rejoint aucun réplica en marche). Sa sonde de démarrage attend 10 min : une grosse montée de version peut être
longue.

Un pod tué pendant une migration laisse `DATABASECHANGELOGLOCK` verrouillé : arrêter tous les pods, libérer le verrou
(`UPDATE DATABASECHANGELOGLOCK SET LOCKED=0`), relancer la migration.

## 4.4. Les réplicas

```sh
kubectl apply -f deploy/k8s/lutece.yaml
kubectl rollout status deployment/lutece-deployment --timeout=5m
```

```yaml
replicas: 2
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 0
    maxSurge: 1
```

Un pod de plus pendant une mise à jour, jamais un de moins.

| Réglage | Valeur | Pourquoi |
|---|---|---|
| `JVM_ARGS` | `-Dliquibase.enabled.at.startup=false -Dforms.internalIndexer.lucene.indexPath=/opt/data/lucene/plugins/forms/index` | Pas de migration par les réplicas ; index Forms sur le volume partagé |
| `serviceAccountName` | `lutece` | Droits de découverte Hazelcast |
| `fsGroup` | `0` | Open Liberty tourne en 1001, groupe 0 : le groupe 0 écrit sur le volume |
| Port 5701 | `hazelcast` | Membre Hazelcast |
| CPU | request 1, limit 2 | Compilation JIT d'OpenJ9 au démarrage ; `executor.threads` = 4 pour 2 CPU |
| Mémoire | 1536 Mi | |
| `startupProbe` | `/health/started`, 36 x 5 s, délai 5 s | Le délai de 1 s par défaut est dépassé quand deux réplicas démarrent ensemble |
| `readinessProbe` | `/health/ready`, délai 5 s | Vérifie la base ; retire un pod lent du Service sans le tuer |
| `livenessProbe` | `/health/live`, délai 10 s, 6 échecs | Avec 1 s, le pod resté seul avec toute la charge après la perte de l'autre était tué à son tour |
| `preStop` | `sleep 10` | Sortir du Service avant l'arrêt d'Open Liberty |
| `initContainers` | `wait-for-mariadb` | Démarré avant la base, Lutece échoue à l'ouvrir et reste non prêt jusqu'à ce que la sonde de démarrage le tue ; aussi dans `lutece-migration.yaml` |
| `terminationGracePeriodSeconds` | 60 | Au-dessus du `preStop` (10 s) et du transfert des partitions (45 s) |

## 4.5. L'ingress

```sh
minikube addons enable ingress
kubectl apply -f deploy/k8s/lutece-ingress.yaml
echo "$(minikube ip) lutece.local" | sudo tee -a /etc/hosts
```

Le site répond sur `http://lutece.local/lutece/`.

| Annotation | Valeur | Pourquoi |
|---|---|---|
| `proxy-next-upstream` | `error timeout` | Rejouer une requête sur un autre pod uniquement quand la connexion au pod a échoué (pod tué, endpoint pas encore retiré). Jamais `non_idempotent` : un POST déjà envoyé (étape de formulaire, action de workflow) ne doit pas être rejoué |
| `proxy-connect-timeout` | `2` | Borne la bascule après l'arrêt brutal d'un pod : p99 2,5 s avec 2 s, 37 s avec 60 s |
| `proxy-body-size` | `20m` | Pièces jointes des formulaires |
| `proxy-read-timeout` | `120` | Au-dessus de la page la plus longue (multivue, export PDF) |

L'affinité de session n'est pas nécessaire. Si elle est ajoutée pour limiter les changements de pod, son cookie ne doit
pas s'appeler `JSESSIONID` : il entrerait en conflit avec celui d'Open Liberty.

Comme pour une instance, le back office exige HTTPS sur une autre adresse que `localhost` : pour un test en HTTP,
`kubectl port-forward service/lutece-service 9090:9090` et `http://localhost:9090/lutece/`.

## 4.6. Vérifier le cluster

```sh
# Planificateur Quartz en cluster : une ligne par réplica (les tables Quartz ont des noms en partie en majuscules)
kubectl exec -it deployment/mariadb -- mariadb -u lutece -psome_password core -e "select INSTANCE_NAME from qrtz_SCHEDULER_STATE"
```

Hazelcast journalise au niveau INFO, que la console d'Open Liberty n'affiche pas par défaut (seulement AUDIT et
au-dessus) : pour voir la composition du cluster (`Members {size:2 ...}`), ajouter `WLP_LOGGING_CONSOLE_LOGLEVEL=INFO`
aux variables du Deployment.

Contrôles fonctionnels :

- Remplir un formulaire en plusieurs étapes en changeant de pod à chaque étape (NodePort ou ingress sans affinité) :
  la réponse est enregistrée avec toutes ses valeurs.
- Se connecter au back office, puis supprimer le pod qui a servi la connexion (`kubectl delete pod ...`) : la session
  continue sur l'autre pod.
- Modifier un formulaire depuis le back office : la modification est visible tout de suite sur les deux pods.
- Redémarrage progressif sous charge (`kubectl rollout restart deployment/lutece-deployment`) : aucune session perdue ;
  seules les requêtes en cours sur le pod arrêté peuvent échouer (1 parcours sur 2 390 mesuré sous 20 usagers).

## 4.7. Mise à jour

Nouvelle image : la mettre dans `lutece-migration.yaml` et `lutece.yaml`, lancer la migration (chapitre 4.3), puis
`kubectl apply -f deploy/k8s/lutece.yaml`. Le redémarrage progressif garde les sessions : chaque pod transfère ses
partitions avant de s'arrêter.

Une nouvelle taille de cache (`core.cache.status.<cache>.maxElementsInMemory`) ne s'applique qu'à la création du cache
dans le cluster : arrêter tous les réplicas (`kubectl scale deployment/lutece-deployment --replicas=0`), puis les
redémarrer.

# 5. Observabilité

Comme pour une instance : `kubectl apply -f deploy/k8s/lgtm.yaml`, `kubectl port-forward service/lgtm 3000:3000`,
Grafana sur `http://localhost:3000` (admin / admin). Le Deployment active l'export OpenTelemetry
(`OTEL_SDK_DISABLED=false`, `OTEL_EXPORTER_OTLP_ENDPOINT=http://lgtm:4317`) ; chaque réplica apparaît avec le même nom
de service (`lutece-guide`) et son propre nom d'hôte.

# 6. Démontage de l'environnement

```sh
kubectl delete -f deploy/k8s/lutece-ingress.yaml
kubectl delete -f deploy/k8s/lutece.yaml
kubectl delete -f deploy/k8s/lutece-base.yaml
kubectl delete -f deploy/k8s/lgtm.yaml
kubectl delete -f deploy/k8s/mariadb-manifest.yaml

eval $(minikube docker-env -u)
minikube stop
minikube delete
```

Sur minikube, supprimer un volume ne supprime pas ses données : elles restent dans
`/tmp/hostpath-provisioner/<namespace>/<nom du volume>` du nœud, et un nouveau volume de même nom dans le même namespace
les retrouve (la base n'est alors pas neuve). Pour repartir d'une base vide sans supprimer le cluster :

```sh
minikube ssh -- sudo rm -rf /tmp/hostpath-provisioner/default/mariadb-pvc
```

# Documentation

- [Dépôt du guide](https://github.com/lutece-platform/lutece-guide-kubernetes-lutece)
- [Lutece](https://lutece.paris.fr/support/) ; [plateforme Lutece : BOM et starters](https://github.com/lutece-platform/lutece-platform)
- [Open Liberty : sessions en cache JCache](https://openliberty.io/docs/latest/distributed-session-caching.html)
- [Hazelcast : near cache](https://docs.hazelcast.com/hazelcast/latest/cluster-performance/near-cache),
  [découverte Kubernetes](https://docs.hazelcast.com/hazelcast/latest/kubernetes/kubernetes-auto-discovery),
  [arrêt gracieux](https://docs.hazelcast.com/hazelcast/latest/maintain-cluster/shutdown)
- [MicroProfile Config 3.1](https://microprofile.io/specifications/config/3-1/),
  [Health 4.0](https://microprofile.io/specifications/health/4-0/),
  [Telemetry 2.0](https://microprofile.io/specifications/telemetry/2-0/)
- [ingress-nginx : annotations](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
- [OpenTelemetry](https://opentelemetry.io/docs/), [Grafana](https://grafana.com/docs/)
