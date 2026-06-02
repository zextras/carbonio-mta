# syntax=docker/dockerfile:1.24

# Stage 1: runs natively on BUILDPLATFORM (amd64 CI builder) — no QEMU.
# Downloads carbonio-postfix + runtime libs for TARGETARCH via apt-get download
# (no dep resolution, no postinst scripts, no service-discover/carbonio-core).
FROM --platform=$BUILDPLATFORM docker.io/library/ubuntu:jammy AS postfix-installer

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
      carbonio-openldap:${TARGETARCH} \
      carbonio-cyrus-sasl:${TARGETARCH} \
      carbonio-mariadb:${TARGETARCH} \
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
 # Stage /etc additions: postfix/postdrop users + groups (postinst scripts are skipped
 # by dpkg -x, so synthesize them here — runs on BUILDPLATFORM, no QEMU needed).
 # UIDs match Debian/Ubuntu carbonio-postfix defaults.
 && mkdir -p /staging/etc \
 && cp /etc/passwd /etc/group /etc/shadow /staging/etc/ \
 && printf 'postfix:x:114:121:Postfix Mail Transport Agent,,,:/var/spool/postfix:/usr/sbin/nologin\n' >> /staging/etc/passwd \
 && printf 'postfix:x:121:\npostdrop:x:122:\n' >> /staging/etc/group \
 && printf 'postfix:!:19000:0:99999:7:::\n' >> /staging/etc/shadow \
 # Chown staged spool/data dirs by numeric UID/GID so ownership survives COPY.
 # spool/. must be root:root; queue subdirs are postfix:postfix; maildrop/public are postfix:postdrop.
 # postqueue/postdrop binaries need root:postdrop + setgid (g+s).
 && chown -R 114:121 /staging/opt/zextras/data/postfix 2>/dev/null || true \
 && chown 0:0 /staging/opt/zextras/data/postfix/spool 2>/dev/null || true \
 && chown 114:122 /staging/opt/zextras/data/postfix/spool/maildrop /staging/opt/zextras/data/postfix/spool/public 2>/dev/null || true \
 && chown 0:122 /staging/opt/zextras/common/sbin/postqueue /staging/opt/zextras/common/sbin/postdrop 2>/dev/null || true \
 && chmod 2755 /staging/opt/zextras/common/sbin/postqueue /staging/opt/zextras/common/sbin/postdrop 2>/dev/null || true \
 && rm -rf /var/lib/apt/lists/*

# Stage 2: final image — TARGETPLATFORM, zero RUN steps (no QEMU needed).
FROM --platform=$TARGETPLATFORM docker.io/library/ubuntu:jammy
USER root

ENV LDAP_ROOT_PASSWORD=qh6hWZvc
ENV LDAP_HOST=openldap
ENV LDAP_PORT=1389
ENV LD_LIBRARY_PATH=/usr/local/lib

EXPOSE 25

COPY --from=postfix-installer /staging/opt /opt
COPY --from=postfix-installer /staging/usr/local/lib /usr/local/lib/
# Merged /etc/{passwd,group,shadow} with postfix + postdrop entries added
COPY --from=postfix-installer /staging/etc/passwd /etc/passwd
COPY --from=postfix-installer /staging/etc/group /etc/group
COPY --from=postfix-installer /staging/etc/shadow /etc/shadow

COPY docker/mta/conf/ /opt/zextras/conf/
COPY docker/mta/postfix_header_checks /opt/zextras/conf/postfix_header_checks
COPY --chmod=755 docker/mta/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
