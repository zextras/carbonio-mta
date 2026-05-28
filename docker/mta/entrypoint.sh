#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2025 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only
#
set -e

# --- Runtime setup that the carbonio-postfix package's postinst would
# --- normally perform. Done here (not in the Dockerfile) so that stage 2
# --- can remain RUN-free and be cross-built without QEMU.

# 1. Create postfix user / postdrop group if missing (idempotent on restart).
#    Mirrors /usr/lib/sysusers.d/carbonio-postfix.conf shipped by carbonio-thirds.
getent group  postdrop >/dev/null || groupadd -r postdrop
getent group  postfix  >/dev/null || groupadd -r postfix
getent passwd postfix  >/dev/null || useradd -r -g postfix -G postdrop \
    -d /opt/zextras/postfix -s /usr/sbin/nologin -c "postfix user" postfix

# 2. Pre-create the log file expected by `tail -f` below.
mkdir -p /var/log
[ -e /var/log/postfix.log ] || install -o postfix -g postfix -m 0644 /dev/null /var/log/postfix.log

# 3. Fix queue-dir ownership/permissions (dpkg -x in the builder left them root-owned).
/opt/zextras/common/sbin/postfix set-permissions >/dev/null

# --- Render templated configs with LDAP connection info.
sed -i -e "s/LDAP_HOST/${LDAP_HOST}/g" /opt/zextras/conf/*.cf
sed -i -e "s/LDAP_PORT/${LDAP_PORT}/g" /opt/zextras/conf/*.cf
sed -i -e "s/LDAP_ROOT_PASSWORD/${LDAP_ROOT_PASSWORD}/g" /opt/zextras/conf/*.cf
sed -i -e "s#LDAP_URL#${LDAP_URL}#g" /opt/zextras/conf/*.cf

/opt/zextras/common/sbin/postconf maillog_file=/var/log/postfix.log

/opt/zextras/common/sbin/postfix start

tail -f /var/log/postfix.log
