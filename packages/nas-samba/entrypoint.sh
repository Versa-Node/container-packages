#!/usr/bin/env bash
set -euo pipefail

: "${SAMBA_USER:=user}"
: "${SAMBA_PASS:=pass}"
: "${SAMBA_SHARE_NAME:=share}"

cat >/etc/samba/smb.conf <<EOF
[global]
   workgroup = WORKGROUP
   server role = standalone server
   map to guest = Bad User
   disable netbios = yes
   smb ports = 445
   log level = 1

[${SAMBA_SHARE_NAME}]
   path = /shares/${SAMBA_SHARE_NAME}
   read only = no
   browsable = yes
   guest ok = no
   valid users = ${SAMBA_USER}
EOF

mkdir -p "/shares/${SAMBA_SHARE_NAME}"
chown -R samba:sambagrp "/shares/${SAMBA_SHARE_NAME}"

# create samba user
( echo "$SAMBA_PASS"; echo "$SAMBA_PASS" ) | smbpasswd -a -s "$SAMBA_USER" || true

exec "$@"
