FROM icr.io/appcafe/open-liberty:kernel-slim-java17-openj9-ubi

ARG VERSION=1.0.0
ARG REVISION=SNAPSHOT

LABEL \
  org.opencontainers.image.authors="YAHIAOUI RAFIK" \
  org.opencontainers.image.vendor="City Paris" \
  org.opencontainers.image.url="local" \
  org.opencontainers.image.source="https://github.com/OpenLiberty/guide-containerize" \
  org.opencontainers.image.version="$VERSION" \
  org.opencontainers.image.revision="$REVISION" \
  vendor="City Paris" \
  name="lutece-site-8" \
  version="$VERSION-$REVISION" \
  summary="The lutece-site  from the Containerizing lutece guide" \
  description="This image contains the lutece-site microservice running with the Open Liberty runtime."

COPY --chown=1001:0 src/main/liberty/config /config/
RUN features.sh
COPY --chown=1001:0 target/lutece-site-1.0.0.war /config/apps
RUN configure.sh