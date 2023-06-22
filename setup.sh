#!/usr/bin/env sh

set -e

NETWORK=${NETWORK:-traefik}
DC=${DC:-"docker compose"}

## Создаем сеть если не существует
if ! docker network inspect ${NETWORK} > /dev/null 2>&1 ; then
    docker network create ${NETWORK}
fi

## Заполняем информацию по сертификатам.
cat <<EOT > dynamic_conf.yml
# Dynamic configuration
tls:
  certificates:
EOT
for key in ./certs/*-key.pem ; do
    key=$(basename $key)
    cert=${key%-key.pem}.pem
    echo "    - certFile: \"/etc/traefik/certs/${cert}\"" >> dynamic_conf.yml
    echo "      keyFile: \"/etc/traefik/certs/${key}\"" >> dynamic_conf.yml
done
echo "" >> dynamic_conf.yml

## Перезапускам сервис 
${DC} up -d --force-recreate

echo "http://localhost:8080"
