#!/bin/bash

export CF_Token=""
export CF_Account_ID=""
DOMAIN="*.qwa.su"
BASEDOMAIN="qwa.su"

get() {
  ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt \
    --issue \
    -d "$DOMAIN" -d "$BASEDOMAIN" \
    --dns dns_cf \
    --keylength ec-256
}

inst() {
  ~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
    --ecc \
    --cert-file /etc/caddy/certs/cert.pem \
    --key-file /etc/caddy/certs/key.pem \
    --fullchain-file /etc/caddy/certs/fullchain.pem \
    --reloadcmd "systemctl reload caddy"
  chown caddy:caddy -R /etc/caddy/certs
  chmod 600 -R /etc/caddy/certs
  chmod 700 /etc/caddy/certs
}

case $1 in
get)
  get
  ;;
inst)
  inst
  ;;
*)
  echo "$0 get|inst"
  ;;
esac
