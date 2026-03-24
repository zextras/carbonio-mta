FROM ubuntu:jammy

USER root

ENV LDAP_ROOT_PASSWORD=qh6hWZvc
ENV LDAP_HOST=openldap
ENV LDAP_PORT=1389
EXPOSE 25

RUN apt update && apt install -y gnupg2 ca-certificates && apt clean && \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52FD40243E584A21 && \
echo deb https://repo.zextras.io/release/ubuntu jammy main > /etc/apt/sources.list.d/zextras.list && \
apt update && apt install -y carbonio-postfix telnet netcat && apt clean

# carbonio-postfix >= 3.10.5-2 uses systemd-sysusers for user creation,
# which is not available in Docker base images. Create users manually.
RUN groupadd -r postdrop 2>/dev/null; \
    groupadd -r postfix 2>/dev/null; \
    useradd -r -g postfix -d /opt/zextras/postfix -s /sbin/nologin -c "postfix user" postfix 2>/dev/null; \
    chgrp postdrop /opt/zextras/common/sbin/postqueue /opt/zextras/common/sbin/postdrop && \
    chmod u=rwx,g=rsx,o=rx /opt/zextras/common/sbin/postqueue /opt/zextras/common/sbin/postdrop && \
    chown postfix /opt/zextras/data/postfix && \
    chown -R postfix:postfix /opt/zextras/data/postfix/spool && \
    chown root:root /opt/zextras/data/postfix/spool && \
    chown postfix:root /opt/zextras/data/postfix/spool/pid && \
    chgrp postdrop /opt/zextras/data/postfix/spool/public && \
    chgrp postdrop /opt/zextras/data/postfix/spool/maildrop && \
    chmod 730 /opt/zextras/data/postfix/spool/maildrop && \
    chown postfix:postdrop /opt/zextras/data/postfix/data && \
    chmod 755 /opt/zextras/data/postfix/data

COPY docker/mta/conf/ /opt/zextras/conf/
COPY docker/mta/postfix_header_checks /opt/zextras/conf/postfix_header_checks
COPY docker/mta/entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
