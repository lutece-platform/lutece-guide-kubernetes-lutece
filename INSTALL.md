# Déploiement pas à pas d'un site Lutece sur Kubernetes — une instance

Ce guide détaille la construction et le déploiement du site de la branche `mono-instance` : un site Lutece 8 (socle
Forms) sur Open Liberty, une base MariaDB et l'observabilité Grafana OTel LGTM, sur minikube.

# Table des matières

- [Prérequis](#prérequis)
- [1. Le site Lutece](#1-le-site-lutece)
  - [1.1. Le pom : BOM et starter](#11-le-pom--bom-et-starter)
  - [1.2. La configuration Open Liberty](#12-la-configuration-open-liberty)
  - [1.3. La configuration Lutece](#13-la-configuration-lutece)
  - [1.4. Lancer le site en local](#14-lancer-le-site-en-local)
- [2. Conteneurisation](#2-conteneurisation)
- [3. Déploiement sur Kubernetes](#3-déploiement-sur-kubernetes)
  - [3.1. MariaDB](#31-mariadb)
  - [3.2. Le site](#32-le-site)
  - [3.3. Profils de configuration](#33-profils-de-configuration)
  - [3.4. Accès au site](#34-accès-au-site)
  - [3.5. Mise à jour](#35-mise-à-jour)
- [4. Observabilité avec Grafana OTel LGTM](#4-observabilité-avec-grafana-otel-lgtm)
- [5. Déploiement avec Open Liberty Operator](#5-déploiement-avec-open-liberty-operator)
- [6. Démontage de l'environnement](#6-démontage-de-lenvironnement)
- [Documentation](#documentation)

## Prérequis

1. Java 21 et Maven 3.9 ou plus.
2. Git.
3. Docker ([documentation](https://docs.docker.com/install/)) ou Podman.
4. Minikube ([documentation](https://minikube.sigs.k8s.io/docs/start/)), démarré avec au moins 4 CPU et 6 Go :
   `minikube start --cpus 4 --memory 6g`.
5. kubectl ([documentation](https://kubernetes.io/docs/tasks/tools/)).

```sh
git clone -b mono-instance https://github.com/lutece-platform/lutece-guide-kubernetes-lutece.git
cd lutece-guide-kubernetes-lutece
```

# 1. Le site Lutece

Un site Lutece (`packaging lutece-site`) ne contient presque pas de code : il assemble le core et des plugins, et porte
leur configuration.

## 1.1. Le pom : BOM et starter

```
lutece-global-pom 8.x  <-  lutece-site-pom 8.x (parent)
site
  dependencyManagement : import fr.paris.lutece.starters:lutece-bom
  dependencies         : fr.paris.lutece.starters:forms-starter + plugin-health
```

- `lutece-bom` fixe la version et le type de chaque artefact Lutece : un plugin du BOM se déclare sans version.
- `forms-starter` apporte le core et les plugins d'un site Forms (forms, genericattributes, workflow et leurs modules).
- `plugin-health` ajoute la vérification de la base à la sonde `/health/ready`.

Le BOM et le starter ont toujours la même version, celle de la propriété `lutece-platform.version`. Les versions
8.0.0-beta-04 et suivantes de la plateforme portent les correctifs nécessaires aux réglages de ce guide (cache,
sérialisation, sondes).

## 1.2. La configuration Open Liberty

Les fichiers de `src/main/liberty/config` sont copiés dans `/config` de l'image.

**`server.xml`**

- **Features** : Jakarta EE (servlet, pages, CDI, JPA, JDBC, mail, REST), MicroProfile Config, Health et Telemetry.
- **Pool de threads borné** :
  ```xml
  <variable name="executor.threads" defaultValue="4" />
  <executor coreThreads="${executor.threads}" maxThreads="${executor.threads}" />
  ```
  Liberty dimensionne son pool tout seul et le fait grossir sous charge, au-delà de ce que le quota CPU du conteneur
  permet : les threads en trop se disputent le CPU, chaque requête en coûte deux fois plus et le débit baisse. Règle :
  threads = CPU x (1 + attente / calcul), soit 4 threads pour une limite de 2 CPU, 7 pour 4, 10 pour 6. La variable
  d'environnement `EXECUTOR_THREADS` la surcharge si la limite CPU du déploiement change.
- **Connexions persistantes** : `<httpOptions persistTimeout="75s"/>`. Liberty ferme une connexion inactive après 30 s,
  ingress-nginx réutilise les siennes jusqu'à 60 s : un POST envoyé sur une connexion que Liberty vient de fermer reçoit
  une 502 et n'est pas rejoué.
- **Adresse du client** : `<remoteIp/>` lit `X-Forwarded-For` quand la connexion vient d'un proxy (adresses privées).
  Sans lui, tous les usagers ont l'adresse de l'ingress et l'anti-DOS des téléversements du core (un fichier de plus de
  10 Ko toutes les 2 s par adresse) les bloque ensemble.
- **Journaux** : `<logging messageFileName="" traceFileName=""/>`, tout va sur la console du conteneur.
- **Source de données** `jdbc/portal` (driver MariaDB du war) et son pool, borné à 12 connexions (environ 3 fois le
  nombre de threads). Chaque `${portal.*}` a une valeur par défaut pour le poste de développement ; en conteneur, la
  variable d'environnement de même nom en majuscules la remplace (`PORTAL_SERVERNAME`, `PORTAL_USER`...).

**`jvm.options`** : `-XX:+ExitOnOutOfMemoryError`. Sur un manque de mémoire, la JVM s'arrête et Kubernetes redémarre le
conteneur, au lieu de continuer dans un état instable.

**`bootstrap.properties`** : vide. La télémétrie est activée par le déploiement (chapitre 4).

## 1.3. La configuration Lutece

**`webapp/WEB-INF/conf/db.properties`** : Lutece obtient ses connexions de la source de données `jdbc/portal` de Liberty.

```properties
portal.poolservice=fr.paris.lutece.util.pool.service.ManagedConnectionService
portal.ds=jdbc/portal
```

**`webapp/WEB-INF/conf/override/profiles-config.properties`** (lu au-dessus des fichiers du core et des plugins) :

- profils `dev`, `rec`, `prod` (chapitre 3.3) ;
- `liquibase.enabled.at.startup=true` : les tables sont créées et mises à jour au démarrage ;
- notifications GRU de `forms-starter` désactivées : aucun service de notification dans ce guide ;
- cache : les valeurs par défaut du core (10 000 entrées, durée de vie 3600 s, pas de niveau offheap). Une valeur propre
  à un cache se donne par `core.cache.status.<nom du cache>.maxElementsInMemory` ou `.timeToLiveSeconds`. Pas de
  `timeToIdleSeconds` : chaque lecture réécrit l'expiration (+19 % de CPU mesuré).

**`webapp/WEB-INF/plugins/plugins.dat`** : sur une base neuve, seuls les plugins listés sont installés.

## 1.4. Lancer le site en local

Lutece a besoin d'une base. Avec un MariaDB local sur le port 3306 :

```sh
mariadb -u root -p < deploy/sql/init.sql
mvn liberty:run
```

`init.sql` ne crée que la base `core`. Le site s'y connecte avec l'utilisateur des variables `portal.user` et
`portal.password` de `server.xml` (`lutece` / `some_password` par défaut), à créer avec ses droits sur `core`, ou à
remplacer au lancement : `-Dliberty.var.portal.user=... -Dliberty.var.portal.password=...`.

Le serveur est prêt quand s'affiche :

    The defaultServer server is ready to run a smarter planet.

Le site répond sur `http://localhost:9090/lutece/`. `mvn liberty:dev` recharge les modifications à chaud ;
`mvn liberty:stop` arrête le serveur. Les goals du plugin sont listés sur [ci.maven](https://github.com/OpenLiberty/ci.maven).

# 2. Conteneurisation

L'image part de l'image officielle `icr.io/appcafe/open-liberty:kernel-slim-java21-openj9-ubi-minimal` : `kernel-slim`
ne contient que le noyau de Liberty, `features.sh` installe les features de `server.xml`.

```sh
# War du site (profil container-runtime : journaux Lutece sur la console d'Open Liberty)
mvn clean lutece:site-assembly -Pcontainer-runtime

# Image dans le Docker de minikube : pas de registre à configurer
eval $(minikube docker-env)
docker build -t lutece-guide-kubernetes:1.0.0-SNAPSHOT .
docker images lutece-guide-kubernetes
```

Avec Podman : `podman build -t lutece-guide-kubernetes:1.0.0-SNAPSHOT .`, puis
`minikube image load lutece-guide-kubernetes:1.0.0-SNAPSHOT`.

Le `Dockerfile` :

```dockerfile
FROM icr.io/appcafe/open-liberty:kernel-slim-java21-openj9-ubi-minimal
COPY --chown=1001:0 src/main/liberty/config /config/
RUN features.sh
COPY --chown=1001:0 target/*.war /config/apps/lutece.war
RUN configure.sh
```

`configure.sh` déploie le war (`/config/apps/expanded`, où `server.xml` trouve le driver JDBC) et remplit le cache de
classes partagé d'OpenJ9, qui accélère les démarrages suivants.

# 3. Déploiement sur Kubernetes

## 3.1. MariaDB

```sh
kubectl apply -f deploy/k8s/mariadb-manifest.yaml
kubectl rollout status deployment/mariadb
```

`deploy/k8s/mariadb-manifest.yaml` crée :

- un Secret `mariadb-credentials` (utilisateur, mot de passe, mot de passe root) ;
- un volume de 2 Gi pour les données ;
- un Deployment `mariadb:11.8` : la base `core` et l'utilisateur `lutece` sont créés au premier démarrage par les
  variables `MARIADB_*` de l'image ; le serveur tourne en UTC, comme les pods Lutece (Lutece écrit et lit des dates sans
  fuseau) ;
- un Service `mariadb-service`.

Mémoire : 512 Mi demandés, 1 Gi au maximum. Les requêtes lourdes du back office (multivue, exports) prennent environ
40 Mo chacune côté serveur : avec 512 Mi, quelques-unes en parallèle suffisent à faire tuer MariaDB.

## 3.2. Le site

```sh
kubectl apply -f deploy/k8s/lutece.yaml
kubectl rollout status deployment/lutece-deployment --timeout=5m
```

`deploy/k8s/lutece.yaml` crée :

- **Secret `db-credentials`** : utilisateur et mot de passe de la base.
- **ConfigMap `lutece-config`** : profil MicroProfile Config.
- **Volume `lutece-data`** (1 Gi) : index Lucene des réponses Forms. Son chemin par défaut (`java.io.tmpdir`) est perdu
  à chaque redémarrage du pod.
- **Deployment `lutece-deployment`**, un réplica.
- **Service `lutece-service`** : NodePort 31000.

Le Deployment :

```yaml
replicas: 1
strategy:
  type: Recreate
```

Une seule instance : le cache Ehcache est local à la JVM, deux réplicas garderaient chacun leurs valeurs périmées. Pour
plusieurs réplicas, voir la branche `multi-instance`. `Recreate` arrête l'ancien pod avant de démarrer le nouveau : le
volume `ReadWriteOnce` ne se monte pas sur deux nœuds, et Liquibase migre la base au démarrage du nouveau pod.

Variables d'environnement :

| Variable | Valeur | Rôle |
|---|---|---|
| `MP_CONFIG_PROFILE` | ConfigMap `lutece-config` | Profil MicroProfile Config |
| `PORTAL_SERVERNAME`, `PORTAL_DBNAME` | `mariadb-service`, `core` | Variables `portal.*` de `server.xml` |
| `PORTAL_USER`, `PORTAL_PASSWORD` | Secret `db-credentials` | Identifiants de la base |
| `JVM_ARGS` | `-Dforms.internalIndexer.lucene.indexPath=/opt/data/lucene/plugins/forms/index` | Index Forms sur le volume |
| `OTEL_SDK_DISABLED`, `OTEL_SERVICE_NAME`, `OTEL_EXPORTER_OTLP_ENDPOINT` | `false`, `lutece-guide`, `http://lgtm:4317` | Télémétrie (chapitre 4) |

Ressources, mesurées avec un parcours de formulaire en front office (k6, 20 usagers) :

```yaml
resources:
  requests: { cpu: "1", memory: 1536Mi }
  limits:   { cpu: "2", memory: 1536Mi }
```

La limite CPU reste au-dessus de la request : pendant les premières minutes sous charge, la compilation JIT d'OpenJ9
occupe environ un tiers de 2 CPU. En JVM chaude, pod saturé (20 usagers sans pause) : 19,7 requêtes/s, p95 1,5 s,
98 ms de CPU par requête ; avec des pauses entre les étapes : p95 130-330 ms à 12 requêtes/s. Si la limite CPU
change, `executor.threads` change avec elle (4 threads pour 2 CPU, 7 pour 4).

Sondes (MicroProfile Health) :

| Sonde | Chemin | Réglage | Pourquoi |
|---|---|---|---|
| startup | `/health/started` | 120 x 5 s (10 min), délai 5 s | Liquibase crée ou migre les tables au démarrage : 3 min ne suffisaient pas pour créer celles de `forms-starter` sur minikube |
| readiness | `/health/ready` | 10 s, délai 5 s | Vérifie la base ; un pod chargé répond lentement (la sonde attend un thread du pool borné) : la readiness le retire du Service, elle ne le tue pas |
| liveness | `/health/live` | 10 s, délai 10 s, 6 échecs | Détecte un pod figé, pas un pod lent |

`preStop` (`sleep 10`) laisse le pod sortir du Service avant l'arrêt d'Open Liberty.

Un conteneur d'initialisation (`wait-for-mariadb`, même image que la base) attend que MariaDB réponde avant de démarrer
Lutece. Sans lui, un pod démarré avant la base échoue à l'ouvrir (Liquibase, puis la webapp) et reste non prêt jusqu'à ce
que la sonde de démarrage le tue, 10 minutes plus tard (vérifié sur minikube).

Un pod tué pendant une migration Liquibase (sonde de démarrage trop courte, limite mémoire, suppression du pod) laisse
la table `DATABASECHANGELOGLOCK` verrouillée : les démarrages suivants affichent `Waiting for changelog lock....` sans
fin. Libérer le verrou, puis redémarrer le pod :

```sh
kubectl exec deployment/mariadb -- mariadb -u lutece -psome_password core -e "UPDATE DATABASECHANGELOGLOCK SET LOCKED=0, LOCKGRANTED=NULL, LOCKEDBY=NULL"
kubectl rollout restart deployment/lutece-deployment
```

## 3.3. Profils de configuration

Un profil MicroProfile Config adapte la configuration à un environnement (dev, rec, prod) avec un seul profil actif.
Le profil vient de la variable d'environnement `MP_CONFIG_PROFILE` (ConfigMap `lutece-config`).

- **Par propriété** : `%<profil>.<clé>` ne s'applique qu'avec ce profil. Avec `dev` actif, `daemon.indexer.onstartup`
  prend la valeur de `%dev.daemon.indexer.onstartup`.
- **Par fichier** : un fichier `microprofile-config-<profil>.properties` est lu par-dessus `microprofile-config.properties`.

En local : `mvn liberty:dev -Dliberty.var.mp.config.profile=dev`.

## 3.4. Accès au site

```sh
minikube ip
```

- Site : `http://<minikube ip>:31000/lutece/`
- Back office : `http://<minikube ip>:31000/lutece/jsp/admin/AdminLogin.jsp` (admin / adminadmin, mot de passe à
  changer à la première connexion)

Le back office envoie l'en-tête CSP `upgrade-insecure-requests` : sur une autre adresse que `localhost`, le navigateur
passe ses requêtes en HTTPS. Pour un test en HTTP :

```sh
kubectl port-forward service/lutece-service 9090:9090
```

puis `http://localhost:9090/lutece/`.

## 3.5. Mise à jour

Nouvelle image : reconstruire avec un nouveau tag, le mettre dans `deploy/k8s/lutece.yaml`, puis
`kubectl apply -f deploy/k8s/lutece.yaml`. Liquibase applique les scripts de mise à jour au démarrage.

Après une modification de la base hors de Lutece (script SQL, restauration), vider les caches depuis le back office
(gestion des caches) : sinon les anciennes valeurs restent servies jusqu'à la fin de leur durée de vie (3600 s).

# 4. Observabilité avec Grafana OTel LGTM

![Composants inclus : OpenTelemetry Collector, Prometheus, Tempo, Loki, Grafana](img/overview.png)

L'image `grafana/otel-lgtm` réunit un collecteur OpenTelemetry, Prometheus, Tempo, Loki et Grafana, pour le
développement et les tests ([présentation](https://grafana.com/blog/2024/03/13/an-opentelemetry-backend-in-a-docker-image-introducing-grafana/otel-lgtm/)).

```sh
kubectl apply -f deploy/k8s/lgtm.yaml
kubectl port-forward service/lgtm 3000:3000
```

Grafana : `http://localhost:3000` (admin / admin).

Le site exporte traces, métriques et journaux (`<mpTelemetry source="message, trace, ffdc"/>` dans `server.xml`).
Liberty désactive l'export par défaut ; le Deployment l'active :

```yaml
- name: OTEL_SDK_DISABLED
  value: "false"
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: http://lgtm:4317
```

Sans collecteur joignable, laisser `OTEL_SDK_DISABLED` à `true` : l'exporteur journaliserait une erreur à chaque envoi.
Ces valeurs ne vont pas dans `bootstrap.properties` ni `server.env` : elles l'emporteraient sur les variables
d'environnement du déploiement.

Journaux des composants LGTM, pour le dépannage : variables `ENABLE_LOGS_GRAFANA`, `ENABLE_LOGS_LOKI`,
`ENABLE_LOGS_PROMETHEUS`, `ENABLE_LOGS_TEMPO`, `ENABLE_LOGS_OTELCOL` ou `ENABLE_LOGS_ALL`.

# 5. Déploiement avec Open Liberty Operator

L'[Open Liberty Operator](https://github.com/OpenLiberty/open-liberty-operator) déploie et gère une application Open
Liberty à partir d'une ressource `OpenLibertyApplication` : il crée le Deployment, le Service et la route, et les garde
dans l'état décrit. C'est une alternative à `deploy/k8s/lutece.yaml` : n'appliquer que l'un des deux.

## Installation de l'opérateur

```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.yaml
kubectl apply --server-side -f https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-crd.yaml

OPERATOR_NAMESPACE=default
WATCH_NAMESPACE='""'
curl -L https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-operator.yaml \
  | sed -e "s/OPEN_LIBERTY_WATCH_NAMESPACE/${WATCH_NAMESPACE}/" \
  | kubectl apply -n ${OPERATOR_NAMESPACE} -f -

kubectl api-resources --api-group=apps.openliberty.io
```

La dernière commande liste les ressources de l'opérateur :

```
NAME                      SHORTNAMES         APIVERSION               NAMESPACED   KIND
openlibertyapplications   olapp,olapps       apps.openliberty.io/v1   true         OpenLibertyApplication
openlibertydumps          oldump,oldumps     apps.openliberty.io/v1   true         OpenLibertyDump
openlibertytraces         oltrace,oltraces   apps.openliberty.io/v1   true         OpenLibertyTrace
```

## Déploiement

```sh
kubectl apply -f deploy/k8s/mariadb-manifest.yaml
kubectl apply -f deploy/openLibertyOperator/lutece-liberty-operator.yaml
kubectl get OpenLibertyApplications
kubectl port-forward svc/lutece 9090:9090
```

Le site répond sur `http://localhost:9090/lutece/`. La ressource reprend l'image, les variables, les ressources et les
sondes de `deploy/k8s/lutece.yaml`.

# 6. Démontage de l'environnement

```sh
kubectl delete -f deploy/openLibertyOperator/lutece-liberty-operator.yaml   # si l'opérateur a été utilisé
kubectl delete -f deploy/k8s/lutece.yaml
kubectl delete -f deploy/k8s/lgtm.yaml
kubectl delete -f deploy/k8s/mariadb-manifest.yaml
```

Désinstallation de l'opérateur et de cert-manager :

```sh
OPERATOR_NAMESPACE=default
WATCH_NAMESPACE='""'
curl -L https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-operator.yaml \
  | sed -e "s/OPEN_LIBERTY_WATCH_NAMESPACE/${WATCH_NAMESPACE}/" \
  | kubectl delete -n ${OPERATOR_NAMESPACE} -f -
kubectl delete -f https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-crd.yaml
kubectl delete -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.yaml
```

Retour à un environnement propre :

```sh
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
- [MicroProfile Config 3.1](https://microprofile.io/specifications/config/3-1/),
  [Health 4.0](https://microprofile.io/specifications/health/4-0/),
  [Telemetry 2.0](https://microprofile.io/specifications/telemetry/2-0/)
- [Open Liberty sur Kubernetes](https://openliberty.io/guides/kubernetes-microprofile-config.html),
  [Open Liberty Operator](https://openliberty.io/guides/openliberty-operator-intro.html),
  [guides Open Liberty](https://openliberty.io/guides/)
- [OpenTelemetry](https://opentelemetry.io/docs/), [Grafana](https://grafana.com/docs/)
