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
  description="Site Lutece Forms sur le runtime Open Liberty."

# server.xml, jvm.options, bootstrap.properties : aucune valeur propre à un environnement
COPY --chown=1001:0 src/main/liberty/config /config/
RUN features.sh
# Construction préalable : mvn clean lutece:site-assembly -Pcontainer-runtime (un seul war dans target/ après "clean")
COPY --chown=1001:0 target/*.war /config/apps/lutece.war
# Déploie le war (/config/apps/expanded) et remplit le cache de classes partagé
RUN configure.sh
