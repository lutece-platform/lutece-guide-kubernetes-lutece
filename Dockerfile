FROM icr.io/appcafe/open-liberty:kernel-slim-java21-openj9-ubi-minimal

ARG VERSION=1.0.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.source="https://github.com/lutece-platform/lutece-guide-kubernetes-lutece" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  name="lutece-guide-kubernetes" \
  version="$VERSION-$REVISION" \
  summary="Site Lutece du guide Kubernetes" \
  description="Site Lutece Forms multi-instance (Hazelcast) sur le runtime Open Liberty."

# server.xml, cluster.xml, fichiers Hazelcast, jvm.options, bootstrap.properties : aucune valeur propre à un environnement
COPY --chown=1001:0 src/main/liberty/config /config/
RUN features.sh
# Construction préalable : mvn clean lutece:site-assembly -Pcontainer-runtime (un seul war dans target/ après "clean")
COPY --chown=1001:0 target/*.war /config/apps/lutece.war
# Hazelcast est dans le war (profil cluster du pom).
# Déploie le war (/config/apps/expanded, lu par la bibliothèque de session de cluster.xml) et remplit le cache de
# classes partagé
RUN configure.sh
