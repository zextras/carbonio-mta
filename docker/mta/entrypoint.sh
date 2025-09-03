#!/usr/bin/env bash
#
# SPDX-FileCopyrightText: 2025 Zextras <https://www.zextras.com>
#
# SPDX-License-Identifier: AGPL-3.0-only
#

sed -i -e "s/LDAP_HOST/${LDAP_HOST}/g" /opt/zextras/conf/*.cf
sed -i -e "s/LDAP_PORT/${LDAP_PORT}/g" /opt/zextras/conf/*.cf
sed -i -e "s/LDAP_ROOT_PASSWORD/${LDAP_ROOT_PASSWORD}/g" /opt/zextras/conf/*.cf
sed -i -e "s#LDAP_URL#${LDAP_URL}#g" /opt/zextras/conf/*.cf

/opt/zextras/common/sbin/postconf maillog_file=/var/log/postfix.log

/opt/zextras/common/sbin/postfix start

tail -f /var/log/postfix.log