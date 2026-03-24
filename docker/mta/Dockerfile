FROM ubuntu:jammy

USER root

ENV LDAP_ROOT_PASSWORD=qh6hWZvc
ENV LDAP_HOST=openldap
ENV LDAP_PORT=1389
EXPOSE 25

RUN apt update && apt install -y gnupg2 ca-certificates systemd-standalone-sysusers && apt clean && \
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 52FD40243E584A21 && \
echo deb https://repo.zextras.io/release/ubuntu jammy main > /etc/apt/sources.list.d/zextras.list && \
apt update && apt install -y carbonio-postfix telnet netcat && apt clean

COPY docker/mta/conf/ /opt/zextras/conf/
COPY docker/mta/postfix_header_checks /opt/zextras/conf/postfix_header_checks
COPY docker/mta/entrypoint.sh .

ENTRYPOINT ["./entrypoint.sh"]
