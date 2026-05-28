# syntax=docker/dockerfile:1.24

# Stage 1: runs natively on BUILDPLATFORM (amd64 CI builder) — no QEMU.
# Downloads carbonio-postfix + runtime libs for TARGETARCH via apt-get download
# (no dep resolution, no postinst scripts, no service-discover/carbonio-core).
FROM --platform=$BUILDPLATFORM ubuntu:jammy AS postfix-installer

ARG TARGETARCH
ARG BUILDARCH=amd64

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates \
 # Cross-arch setup when TARGETARCH != BUILDARCH
 && if [ "${TARGETARCH}" != "${BUILDARCH}" ]; then \
      dpkg --add-architecture ${TARGETARCH} \
      && sed -i 's|^deb |deb [arch='"${BUILDARCH}"'] |' /etc/apt/sources.list \
      && printf 'Types: deb\nURIs: http://ports.ubuntu.com/ubuntu-ports/\nSuites: jammy jammy-updates jammy-security\nComponents: main restricted universe multiverse\nArchitectures: %s\nSigned-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg\n' "${TARGETARCH}" \
         > /etc/apt/sources.list.d/ports-${TARGETARCH}.sources; \
    fi \
 && printf 'deb [arch=%s trusted=yes] https://repo.area51-zextras.com/devel/ubuntu jammy main\n' "${TARGETARCH}" \
    > /etc/apt/sources.list.d/zextras.list \
 && apt-get update \
 # Download only the packages needed to run postfix — no dep resolution, no carbonio-core
 && mkdir -p /staging /tmp/debs && cd /tmp/debs \
 && apt-get download \
      carbonio-postfix:${TARGETARCH} \
      carbonio-icu:${TARGETARCH} \
      carbonio-openssl:${TARGETARCH} \
      carbonio-cyrus-sasl:${TARGETARCH} \
      liblmdb0:${TARGETARCH} \
      libnsl2:${TARGETARCH} \
      libpcre3:${TARGETARCH} \
      libsystemd0:${TARGETARCH} \
 # Extract all debs with dpkg -x — no postinst scripts run
 && for deb in /tmp/debs/*.deb; do dpkg -x "$deb" /staging; done \
 && rm -rf /tmp/debs \
 # Collect arch-specific libs into /staging/usr/local/lib for arch-independent COPY
 && mkdir -p /staging/usr/local/lib \
 && find /staging/lib /staging/usr/lib -name '*.so*' -not -path '*/opt/*' \
    -exec cp -P {} /staging/usr/local/lib/ \; 2>/dev/null || true \
 && rm -rf /var/lib/apt/lists/*

# Stage 2: final image — TARGETPLATFORM, zero RUN steps (no QEMU needed).
FROM --platform=$TARGETPLATFORM ubuntu:jammy
USER root

ENV LDAP_ROOT_PASSWORD=qh6hWZvc
ENV LDAP_HOST=openldap
ENV LDAP_PORT=1389
ENV LD_LIBRARY_PATH=/usr/local/lib

EXPOSE 25

COPY --from=postfix-installer /staging/opt /opt
COPY --from=postfix-installer /staging/usr/local/lib /usr/local/lib/

COPY docker/mta/conf/ /opt/zextras/conf/
COPY docker/mta/postfix_header_checks /opt/zextras/conf/postfix_header_checks
COPY --chmod=755 docker/mta/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
