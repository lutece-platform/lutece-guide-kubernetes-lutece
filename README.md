# Guide de déploiement Lutece sur Kubernetes — une instance
![Lutece logo](https://github.com/lutece-platform/lutece-core/blob/develop/webapp/images/Lutece-logo.png?raw=true)

Ce guide déploie un site Lutece 8 (socle Forms) sur Kubernetes, avec le runtime Open Liberty, une base MariaDB et
l'observabilité de la suite Grafana OTel LGTM.

Cette branche (`mono-instance`) fait tourner le site en **une seule instance** : la session HTTP et le cache Lutece
(Ehcache) restent dans la JVM du pod. Pour plusieurs réplicas derrière un répartiteur, voir la branche
[`multi-instance`](https://github.com/lutece-platform/lutece-guide-kubernetes-lutece/tree/multi-instance).

**Le guide pas à pas, avec le détail de chaque fichier : [INSTALL.md](INSTALL.md)**

## Table des matières

1. [Objectifs](#objectifs)
2. [Prérequis](#prérequis)
3. [Démarrage rapide](#démarrage-rapide)
4. [Le site](#le-site)
5. [Conteneurisation](#conteneurisation)
6. [Déploiement sur Kubernetes](#déploiement-sur-kubernetes)
7. [Réglages de performance](#réglages-de-performance)
8. [Observabilité](#observabilité)
9. [Open Liberty Operator](#open-liberty-operator)
10. [Dépannage](#dépannage)

## Objectifs

- Construire un site Lutece 8 à partir du BOM et d'un starter de la plateforme
- Le lancer en local sur Open Liberty, puis en conteneur
- Le déployer sur Kubernetes (minikube) avec une base MariaDB
- Le dimensionner (CPU, mémoire, threads, connexions, sondes)
- Exporter traces, métriques et journaux vers Grafana OTel LGTM

## Prérequis

- Java 21 et Maven 3.9 ou plus
- Git
- Docker (ou Podman)
- Minikube et kubectl

## Démarrage rapide

```sh
git clone -b mono-instance https://github.com/lutece-platform/lutece-guide-kubernetes-lutece.git
cd lutece-guide-kubernetes-lutece

# War du site, puis image construite dans le Docker de minikube
mvn clean lutece:site-assembly -Pcontainer-runtime
eval $(minikube docker-env)
docker build -t lutece-guide-kubernetes:1.0.0-SNAPSHOT .

# Base de données, observabilité, site
kubectl apply -f deploy/k8s/mariadb-manifest.yaml
kubectl rollout status deployment/mariadb
kubectl apply -f deploy/k8s/lgtm.yaml
kubectl apply -f deploy/k8s/lutece.yaml
kubectl rollout status deployment/lutece-deployment --timeout=5m
```

- Site : `http://<minikube ip>:31000/lutece/`
- Back office : `http://<minikube ip>:31000/lutece/jsp/admin/AdminLogin.jsp` (admin / adminadmin, mot de passe à
  changer à la première connexion)
- Grafana : `kubectl port-forward service/lgtm 3000:3000`, puis `http://localhost:3000` (admin / admin)

`minikube ip` donne l'adresse du nœud. Le back office exige HTTPS sur une autre adresse que `localhost` (en-tête CSP
`upgrade-insecure-requests`) : pour un test en HTTP, passer par `kubectl port-forward service/lutece-service 9090:9090`
et `http://localhost:9090/lutece/`.

## Le site

| Fichier | Rôle |
|---|---|
| `pom.xml` | Parent `lutece-site-pom`, BOM `lutece-bom` et `forms-starter` de la plateforme (même version, propriété `lutece-platform.version`), `plugin-health` pour les sondes |
| `src/main/liberty/config/server.xml` | Features Liberty, pool de threads borné, connexions persistantes, adresse du client derrière un proxy, source de données MariaDB et son pool |
| `src/main/liberty/config/jvm.options` | Arrêt de la JVM sur un manque de mémoire |
| `webapp/WEB-INF/conf/db.properties` | Lutece utilise la source de données `jdbc/portal` de Liberty |
| `webapp/WEB-INF/conf/override/profiles-config.properties` | Profils MicroProfile Config, Liquibase au démarrage, notifications désactivées, cache |
| `webapp/WEB-INF/plugins/plugins.dat` | Plugins installés sur une base neuve |
| `deploy/sql/init.sql` | Création de la base pour un MariaDB local |

La version de la plateforme se change en un seul endroit :

```xml
<lutece-platform.version>8.0.0-beta-04</lutece-platform.version>
```

Elle se surcharge aussi à la construction : `mvn ... -Dlutece-platform.version=8.0.0-SNAPSHOT`.

Les tables sont créées par Liquibase au premier démarrage (`liquibase.enabled.at.startup=true`) : aucun dump SQL n'est
nécessaire.

### Lancer le site en local

Avec un MariaDB local (port 3306) initialisé par `deploy/sql/init.sql` :

```sh
mvn liberty:run        # ou liberty:dev
```

Le site répond sur `http://localhost:9090/lutece/`.

## Conteneurisation

L'image part de `icr.io/appcafe/open-liberty:kernel-slim-java21-openj9-ubi-minimal` : `features.sh` installe les
seules features de `server.xml`, `configure.sh` déploie le war et remplit le cache de classes.

```sh
mvn clean lutece:site-assembly -Pcontainer-runtime
docker build -t lutece-guide-kubernetes:1.0.0-SNAPSHOT .
```

Le profil `container-runtime` envoie les journaux de Lutece sur la console d'Open Liberty.

## Déploiement sur Kubernetes

| Fichier | Ressources |
|---|---|
| `deploy/k8s/mariadb-manifest.yaml` | Secret, volume, Deployment MariaDB 11.8 (UTC, utf8mb4), Service `mariadb-service` |
| `deploy/k8s/lutece.yaml` | Secret des identifiants, ConfigMap du profil, volume de l'index Forms, Deployment (1 réplica), Service NodePort 31000 |
| `deploy/k8s/lgtm.yaml` | Grafana OTel LGTM |

Le Deployment fournit au site, par variables d'environnement :

- la base : `PORTAL_SERVERNAME`, `PORTAL_DBNAME`, `PORTAL_USER`, `PORTAL_PASSWORD` (variables `portal.*` de
  `server.xml`) ;
- le profil MicroProfile Config : `MP_CONFIG_PROFILE` ;
- le chemin de l'index Lucene des réponses Forms, sur un volume (`JVM_ARGS`) ;
- la télémétrie : `OTEL_SDK_DISABLED`, `OTEL_SERVICE_NAME`, `OTEL_EXPORTER_OTLP_ENDPOINT`.

Un seul réplica, stratégie `Recreate` : le cache Ehcache est local à la JVM (deux réplicas garderaient chacun leurs
valeurs périmées) et le volume `ReadWriteOnce` ne se monte pas sur deux nœuds.

### Profils de configuration

Le profil actif vient de `MP_CONFIG_PROFILE` (ConfigMap `lutece-config`). Une clé `%<profil>.<clé>` ne s'applique
qu'avec ce profil :

```properties
%dev.daemon.indexer.onstartup=0
%prod.daemon.indexer.onstartup=1
```

En local : `mvn liberty:dev -Dliberty.var.mp.config.profile=dev`.

## Réglages de performance

Mesurés sur minikube (un nœud), avec un parcours de remplissage et de soumission de formulaire en front office
(k6, 20 usagers) :

| Réglage | Valeur | Pourquoi |
|---|---|---|
| CPU | request 1, limit 2 | La compilation JIT d'OpenJ9 occupe environ un tiers de 2 CPU pendant les premières minutes sous charge |
| Mémoire | 1536 Mi | Heap par défaut d'OpenJ9 en conteneur ; la JVM s'arrête sur un manque de mémoire (`-XX:+ExitOnOutOfMemoryError`) |
| Threads Liberty | 4 (`executor.threads`) | Borné à la limite CPU : sans borne, le pool grossit, les threads se disputent le CPU et le débit baisse sous charge |
| Connexions | `maxPoolSize` 12 | Environ 3 fois le nombre de threads |
| Connexions persistantes | `persistTimeout` 75 s | Au-dessus des 60 s d'ingress-nginx : sinon un POST sur une connexion fermée reçoit une 502 |
| Adresse du client | `<remoteIp/>` | Derrière l'ingress, l'anti-DOS des téléversements bloquerait tous les usagers ensemble |
| Cache Ehcache | valeurs par défaut du core | 10 000 entrées, 3600 s, pas d'offheap ; ne pas utiliser `timeToIdleSeconds` (+19 % de CPU) |

Mesures de ce guide sur minikube (k6, 20 usagers qui enchaînent sans pause les étapes d'un formulaire, pod saturé) :

| Passage | Requêtes/s | p50 | p95 | Erreurs | CPU / requête |
|---|---|---|---|---|---|
| Premières minutes (JIT) | 8,4 | 1,9 s | 3,9 s | 0 | 237 ms |
| JVM chaude | 19,7 | 0,76 s | 1,5 s | 0 | 98 ms |

19,7 requêtes/s est la capacité d'un pod de 2 CPU. Avec des pauses entre les étapes (usage réel), le même site tient un
p95 de 130 à 330 ms à 12 requêtes/s. Pendant les premières minutes, la compilation JIT rallonge nettement les temps de
réponse : mesurer après une chauffe. Premier démarrage sur une base neuve : 5 à 8 min (création des tables).

### Sondes

| Sonde | Chemin | Réglage |
|---|---|---|
| startup | `/health/started` | 10 min (120 x 5 s) : Liquibase crée ou migre les tables au démarrage ; un pod tué pendant une migration laisse la base verrouillée |
| readiness | `/health/ready` | vérifie la base (`plugin-health`), délai 5 s |
| liveness | `/health/live` | délai 10 s, 6 échecs : un pod lent n'est pas tué, un pod figé l'est |

## Observabilité

Le site exporte traces, métriques et journaux au format OpenTelemetry (`mpTelemetry-2.1`). L'export est désactivé par
défaut par Liberty et activé par le Deployment (`OTEL_SDK_DISABLED=false`, `OTEL_EXPORTER_OTLP_ENDPOINT=http://lgtm:4317`).
Ces valeurs ne sont pas mises dans `bootstrap.properties` : une propriété système l'emporte sur la variable
d'environnement du conteneur.

`grafana/otel-lgtm` réunit un collecteur OpenTelemetry, Prometheus, Tempo, Loki et Grafana dans une image, pour le
développement et les tests.

![Composants inclus : OpenTelemetry Collector, Prometheus, Tempo, Loki, Grafana](img/overview.png)

## Open Liberty Operator

`deploy/openLibertyOperator/lutece-liberty-operator.yaml` déploie la même image avec l'Open Liberty Operator, à la place
de `deploy/k8s/lutece.yaml`. L'installation de l'opérateur est décrite dans [INSTALL.md](INSTALL.md#5-déploiement-avec-open-liberty-operator).

## Dépannage

```sh
kubectl logs deployment/lutece-deployment          # journaux Liberty et Lutece
kubectl exec -it deployment/mariadb -- mariadb -u lutece -psome_password core
```

Journaux des composants LGTM : variables `ENABLE_LOGS_GRAFANA`, `ENABLE_LOGS_LOKI`, `ENABLE_LOGS_PROMETHEUS`,
`ENABLE_LOGS_TEMPO`, `ENABLE_LOGS_OTELCOL` ou `ENABLE_LOGS_ALL` dans `deploy/k8s/lgtm.yaml`.

## Contribution

1. Forker le projet
2. Créer une branche
3. Soumettre une Pull Request

## Licence

[Licence du projet](LICENSE)

## Documentation

- [Lutece](https://lutece.paris.fr/support/)
- [Plateforme Lutece : BOM et starters](https://github.com/lutece-platform/lutece-platform)
- [MicroProfile Config 3.1](https://microprofile.io/specifications/config/3-1/),
  [Health 4.0](https://microprofile.io/specifications/health/4-0/),
  [Telemetry 2.0](https://microprofile.io/specifications/telemetry/2-0/)
- [Open Liberty sur Kubernetes](https://openliberty.io/guides/kubernetes-microprofile-config.html),
  [Open Liberty Operator](https://github.com/OpenLiberty/open-liberty-operator)
- [OpenTelemetry](https://opentelemetry.io/docs/), [Grafana](https://grafana.com/docs/)
