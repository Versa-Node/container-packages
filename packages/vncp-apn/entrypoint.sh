#!/usr/bin/env bash
set -euo pipefail

: "${APN_NAME:=internet}"
: "${APN_USER:=}"
: "${APN_PASSWORD:=}"
: "${DIAL_NUMBER:=*99#}"
: "${MODEM_DEV:=/dev/ttyUSB0}"

mkdir -p /etc/ppp/peers /etc/chatscripts

cat >/etc/ppp/peers/provider <<EOF
${MODEM_DEV}
115200
crtscts
modem
usepeerdns
defaultroute
noauth
persist
connect '/usr/sbin/chat -v -f /etc/chatscripts/provider'
EOF

cat >/etc/chatscripts/provider <<EOF
ABORT 'BUSY'
ABORT 'NO CARRIER'
ABORT 'NO DIALTONE'
ABORT 'ERROR'
ABORT 'NO ANSWER'
TIMEOUT 12
'' AT
OK ATZ
OK AT+CGDCONT=1,"IP","${APN_NAME}"
OK ATD${DIAL_NUMBER}
CONNECT ''
EOF

if [[ -n "${APN_USER}" ]]; then
  echo ""${APN_USER}" * "${APN_PASSWORD}"" > /etc/ppp/pap-secrets
  echo ""${APN_USER}" * "${APN_PASSWORD}"" > /etc/ppp/chap-secrets
fi

exec pppd call provider nodetach
