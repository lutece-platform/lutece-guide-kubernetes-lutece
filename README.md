# Guide de Déploiement Lutece sur Kubernetes
![Lutece logo](https://github.com/lutece-platform/lutece-core/blob/develop/webapp/images/Lutece-logo.png?raw=true)

Ce guide fournit des instructions pour déployer une application Lutece sur Kubernetes avec un runtime Open Liberty et une base de données Mariadb, incluant l'observabilité via la suite Grafana OTel LGTM.

**Pour suivre le guide étape par étape avec une description détaillée des instructions [Documentation détaillée du guide](INSTALL.md)**

> **Lutece 8, socle Forms : le guide est mis à jour sur deux branches**
>
> - [`mono-instance`](https://github.com/lutece-platform/lutece-guide-kubernetes-lutece/tree/mono-instance) : le site en
>   une seule instance (session et cache Ehcache dans la JVM), dimensionné et mesuré sous charge.
> - [`multi-instance`](https://github.com/lutece-platform/lutece-guide-kubernetes-lutece/tree/multi-instance) : le site
>   en plusieurs réplicas, session HTTP et cache Lutece partagés par Hazelcast, daemons en cluster, migrations depuis un
>   seul pod.
>
> Cette branche `master` garde la première version du guide (site minimal, lutece-core seul).

## 📋 Table des matières

1. [Objectifs](#objectifs)
2. [Prérequis](#prerequis)
3. [Conteneurisation de Lutece](#conteneurisation-de-lutece)
4. [Déploiement sur Kubernetes](#deploiement-sur-kubernetes)
5. [Observabilité avec docker-otel-lgtm](#observabilite-avec-docker-otel-lgtm)
6. [Déploiement de MariaDB sur Kubernetes avec Scripts d'Initialisation](#deploiement-de-mariadb-sur-kubernetes-avec-le-scripts-d-initialisation)
7. [Déploiement de Lutece sur Kubernetes avec Open Liberty Operator](#deploiement-de-lutece-sur-kubernetes-avec-open-liberty-operator)

## 🎯 Objectifs

Ce guide vous permettra de :
- Exécuter une application Lutece sur Open Liberty et une bdds MariadDB
- Construire une image Docker de l'application lutece
- Déployer l'application sur Kubernetes (minikube)
- Configurer une base de données MariaDB
- Mettre en place l'observabilité avec Grafana OTel LGTM

## 🛠 Prerequis

### Logiciels requis

- Java 17+
- Maven 3.6.0+
- Git
- Docker
- Minikube
- kubectl

### Installation

```bash
git clone https://github.com/lutece-platform/guide-kubernetes-lutece.git
cd guide-kubernetes-lutece
```

Pour déployer tous les pods Lutece, MariaDB, ainsi que le pod d'observabilité Grafana OTel LGTM, vous pouvez exécuter les commandes ci-dessous. Les détails de chaque étape sont expliqués dans les chapitres suivants :

```sh
# Partie base de données 

kubectl create configmap mariadb-init-sql --from-file=src/sql/init.sql
kubectl create configmap mariadb-dump-sql --from-file=src/sql/dump.sql
kubectl apply -f deploy/k8s/mariadb-manifest.yaml

# Partie application lutece

kubectl apply -f deploy/k8s/lutece.yaml

# Partie observabilité

kubectl apply -f deploy/k8s/lgtm.yaml
kubectl port-forward service/lgtm 3000:3000

```

🌐 **Accès à l'application Lutece et grafana**

- URL grafana: `http://localhost:3000`
- Identifiants : admin/admin
- URL lutece: `http://<minikube_ip>:31000/lutece/jsp/admin/AdminLogin.jsp`
- Identifiants : admin/adminadmin

Obtention de l'IP Minikube :
	
	minikube ip

## 📦 Conteneurisation de Lutece

Cette section explique comment builder une image Lutece avec un image de base Open Liberty en utilisant Docker.

Si vous préférez ne pas suivre cette étape, vous pouvez passer directement au chapitre [Déploiement sur Kubernetes](#deploiement-sur-kubernetes), car l'image Docker de Lutece pour ce projet est déjà disponible sur Docker Hub.

**Image lutece** 

```sh
docker pull rafikyahiaoui/lutece-site-8:1.0.0-SNAPSHOT
```
### Empaquetage de l'application

1. Test local avec Maven :
Lutece nécessite une base de données pour fonctionner. Avant de lancer l'application, il est donc indispensable d'installer un serveur de base de données, puis de créer la base en utilisant les scripts disponibles dans le répertoire src/sql

```sh
# lancer lutece

mvn liberty:run

# lancer lutece en mode developpement

mvn liberty:dev

#lancer lutece en mode developpement sur un conteneur

mvn liberty:devc   
```
2. Accès à l'application locale :

	http://localhost:9090/lutece

3. Création du WAR :

	mvn clean lutece:war

### Construction de l'image Docker

```bash
docker build -t lutece-site-8:1.0.0-SNAPSHOT .
```

## 🚀 Deploiement sur Kubernetes

### Ressources Kubernetes pou l'application lutece

Se référer au fichier `deploy/k8s/lutece.yaml` pour les détails.

### Profils de Configuration
Les **Profils de Configuration** permettent de configurer l'application lutece pour différents environnements et étapes de développement (ex. dev, test, prod) tout en ayant un seul profil actif à la fois. Le profil actif est spécifié à l’aide de la propriété `mp.config.profile`, qui peut être définie dans n’importe quelle source de configuration (ConfigSource).
### Utilisation des Profils de Configurationon
Le profil de configuration actif peut être défini de plusieurs manières dans Kubernetes 
1. **Dans un ConfigMap** : Le profil peut être stocké dans un ConfigMap, mappé ensuite à une variable d'environnemen.

2. **Directement en tant que variable d'environnement** : Dans le fichier YAML de déploiement, la propriété est définie en tant que variable d'environnement `MP_CONFIG_PROFILE`, compatible avec tous les systèmes d'exploitation.

#### Format des Propriétés de Configuration par Profil

La propriété `mp.config.profile` peut être utilisée :

- **Au niveau de la propriété** : Les noms de propriétés de configuration peuvent être définis dans le format suivant, pour qu'ils soient appliqués en fonction du profil sélectionné :
  - `%<mp.config.profile>.<nom original de la propriété>`
  - Exemple : Avec `mp.config.profile` défini à `dev`, la récupération de la configuration pour `server.host` utilisera la propriété `%dev.server.host`.

### Déploiement

Avant de déployer les ressources Lutece, il faut d'abord déployer les ressources MariaDB en exécutant la commande ci-dessous. Pour plus de détails, veuillez vous référer au chapitre suivant. [Déploiement de MariaDB sur Kubernetes avec Scripts d'Initialisation](#deploiement-de-mariadb-sur-kubernetes-avec-le-scripts-d-initialisation)

	kubectl create configmap mariadb-init-sql --from-file=src/sql/init.sql
	kubectl create configmap mariadb-dump-sql --from-file=src/sql/dump.sql
	kubectl apply -f deploy/k8s/mariadb-manifest.yaml

Pour déployer les ressources lutece sur votre cluster Kubernetes, utilisez la commande suivante:

	kubectl apply -f deploy/k8s/lutece.yaml
Cela créera et configurera les ressources spécifiées dans le fichier YAML. L'application Lutece est également configurée pour exporter les données de télémétrie (métriques, traces et journaux) au format OpenTelemetry. La configuration pour l'activation ainsi que l'URL d'exportation des données de télémétrie se trouve dans le fichier src/main/liberty/config/bootstrap.properties

	otel.sdk.disabled=false	
	otel.exporter.otlp.endpoint=http://lgtm:4317/
### 🌐 Accès à l'application Lutece

1. Obtention de l'IP Minikube :
```bash
minikube ip
```

2. Accès à l'interface d'administration :
- URL : `http://<minikube_ip>:31000/lutece/jsp/admin/AdminLogin.jsp`
- Identifiants : admin/adminadmin


## 📊 Observabilite avec docker-otel-lgtm

### Composants inclus

Une solution backend OpenTelemetry dans une image Docker.![Composants inclus dans l'image Docker : OpenTelemetry Collector, Prometheus, Tempo, Loki, Grafana](img/overview.png)

L’image Docker `grafana/otel-lgtm` est une solution backend open-source pour OpenTelemetry, adaptée aux environnements de développement, de démonstration et de test. Pour une solution prête pour la production, permettant de surveiller des applications et de minimiser le MTTR (temps moyen de résolution) avec OpenTelemetry et Prometheus, essayez [Grafana Cloud Application Observability](https://grafana.com/products/cloud/application-observability/).

### Documentationon
* Article de blog : [Un backend OpenTelemetry dans une image Docker : Présentation de grafana/otel-lgtm](https://grafana.com/blog/2024/03/13/an-opentelemetry-backend-in-a-docker-image-introducing-grafana/otel-lgtm/)

### Déploiement

1. Application des ressources :

	kubectl apply -f deploy/k8s/lgtm.yaml

2. Configuration du port-forwarding :

	kubectl port-forward service/lgtm 3000:3000

### Accès Grafana
- URL : `http://localhost:3000`
- Identifiants : admin/admin

## 💾 Deploiement de mariadb sur kubernetes avec le scripts d'initialisation

### Initialisation

1. Création des ConfigMaps :
	
	kubectl create configmap mariadb-init-sql --from-file=src/sql/init.sql
	kubectl create configmap mariadb-dump-sql --from-file=src/sql/dump.sql

2. Déploiement :

	kubectl apply -f deploy/k8s/mariadb-manifest.yaml

### Structure du déploiement

- PersistentVolumeClaim pour le stockage
- ConfigMaps pour les scripts d'initialisation
- Deployment pour MariaDB
- Service pour l'exposition interne

### Accès à MariaDB
	kubectl exec -it <mariadb-pod-name> -- mysql -u lutece -psome_password

## Deploiement de lutece sur Kubernetes avec Open Liberty Operator

Cette section présente **une alternative au déploiement initial de Lutece qui utilisait directement les ressources gérées nativement par Kubernetes**. Ce chapitre vous permettra de déployer le site Lutece en utilisant l’Open Liberty Operator, qui facilite le packaging, le déploiement et la gestion des applications Open Liberty sur des clusters Kubernetes. Cet opérateur surveille les ressources Open Liberty et crée divers composants Kubernetes, tels que des déploiements, des services et des routes, en fonction des configurations. Il garantit également la mise à jour des ressources selon l'état souhaité de l'application, en comparant et en synchronisant les états actuel et attendu. [OpenLiberty Operator](https://github.com/OpenLiberty/open-liberty-operator).

### Installation de l’Opérateur

Avant de déployer votre site, vous devez installer le cert-manager et l'Open Liberty Operator. Pour plus de détails, consultez les instructions d’installation.

Pour commencer, installez le cert-manager sur votre cluster Kubernetes en exécutant la commande suivante :

```sh
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.3/cert-manager.yaml
```
Ensuite, installez les Custom Resource Definitions (CRDs) pour l'Open Liberty Operator en exécutant la commande suivante :

```sh
kubectl apply --server-side -f https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-crd.yaml
```
Enfin, exécutez les commandes suivantes pour installer l'Opérateur :

```sh
curl -L https://raw.githubusercontent.com/OpenLiberty/open-liberty-operator/main/deploy/releases/1.2.1/kubectl/openliberty-app-operator.yaml \
  | sed -e "s/OPEN_LIBERTY_WATCH_NAMESPACE/${WATCH_NAMESPACE}/" \
  | kubectl apply -n ${OPERATOR_NAMESPACE} -f -
```
Pour vérifier que l’Open Liberty Operator a bien été installé, exécutez la commande suivante pour afficher toutes les ressources d’API prises en charge et disponibles via l'Open Liberty Operator :

```sh
kubectl api-resources --api-group=apps.openliberty.io
```

Recherchez la sortie suivante, qui affiche les Custom Resource Definitions (CRDs) pouvant être utilisées par l'Open Liberty Operator :

```sh
NAME                      SHORTNAMES         APIVERSION               NAMESPACED   KIND
openlibertyapplications   olapp,olapps       apps.openliberty.io/v1   true         OpenLibertyApplication
openlibertydumps          oldump,oldumps     apps.openliberty.io/v1   true         OpenLibertyDump
openlibertytraces         oltrace,oltraces   apps.openliberty.io/v1   true         OpenLibertyTrace
```
Chaque Custom Resource Definition (CRD) définit un type d'objet pouvant être utilisé, comme spécifié dans l'exemple précédent par la valeur KIND. La valeur SHORTNAME indique des noms alternatifs que vous pouvez utiliser dans la configuration pour faire référence à un type d'objet. Par exemple, vous pouvez référencer le type d'objet OpenLibertyApplication en utilisant l'un de ses noms courts spécifiés, tel que "olapps".

La CRD openlibertyapplications définit un ensemble de configurations pour déployer une application basée sur Open Liberty, incluant l'image de l'application, le nombre d'instances et les paramètres de stockage. L'Open Liberty Operator surveille les modifications apportées aux instances du type d'objet OpenLibertyApplication et crée des ressources Kubernetes basées sur la configuration définie dans la CRD.

### Déploiement :
```sh
kubectl apply -f deploy/openLibertyOperator/lutece-liberty-operator.yaml
```
Ensuite, exécutez la commande suivante pour afficher vos ressources OpenLibertyApplications nouvellement créées :

```sh
kubectl get OpenLibertyApplications
```
### 🌐 Accès à l'application Lutece

```sh
kubectl port-forward svc/lutece 9443
```
Visitez le microservice à l'adresse suivante : 

	https://localhost:9443/lutece/jsp/admin/AdminLogin.jsp


## 🔍 Dépannage

### Logs des composants

Variables d'environnement pour activer les logs :
- `ENABLE_LOGS_GRAFANA` : Logs Grafana
- `ENABLE_LOGS_LOKI` : Logs Loki
- `ENABLE_LOGS_PROMETHEUS` : Logs Prometheus
- `ENABLE_LOGS_TEMPO` : Logs Tempo
- `ENABLE_LOGS_OTELCOL` : Logs OpenTelemetry Collector
- `ENABLE_LOGS_ALL` : Tous les logs

## 🤝 Contribution

Les contributions sont les bienvenues ! Merci de :
1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Soumettre une Pull Request

## 📄 Licence

* The open source [Project License](LICENSE) 

## 📚 Documentation additionnelle

- [Documentation détaillée du guide](https://dev.lutece.paris.fr/gitlab/archi/comite-achitecture/-/wikis/Guide-de-D%C3%A9ploiement-Lutece-sur-Kubernetes#213-deployment--lutece-deployment)
- [Documentation microprofile telemetry 2.0](https://microprofile.io/specifications/telemetry/2-0/)
- [Documentation microprofile config api 3.1](https://microprofile.io/specifications/config/3-1/)
- [Documentation microprofile health 4.0 ](https://microprofile.io/specifications/health/4-0/)
- [Documentation OpenTelemetry](https://opentelemetry.io/docs/)
- [Documentation Grafana](https://grafana.com/docs/)
- [Documentation Lutece](https://lutece.paris.fr/support/)
- [Documentation openLiberty kuberntes](https://openliberty.io/guides/kubernetes-microprofile-config.html)
- [Documentation openLiberty kuberntes Operator](https://openliberty.io/guides/openliberty-operator-intro.html)
- [Repo Open Liberty Operator](https://github.com/OpenLiberty/open-liberty-operator)
- [Quickest way to learn all things Open Liberty, and beyond!](https://openliberty.io/guides/)