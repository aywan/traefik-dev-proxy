# Traefik

Traefik - edge-proxy.

Четрые основные сущности:
1. Точки входа - некоторые UDP/TCP порты которые слушает программа.
1. Router - правила по которым происходит направления трафика, например хост, путь или порт.
1. Middleware - некоторые преднастроенные скрипты которые позволяют осуществлять такие операции как фильтрация, перенапралвление, авторизацию, аутентификацию и пр.
1. Sercvice - некоторый сервис предоставляющий порт для трафика, который занимается непосредственно обработкой запроса.

## Установка

1. Клонировать репозиторий локально
1. Установить [mkcert](https://github.com/FiloSottile/mkcert)
    1. Установить любым из доступных способов (brew, source, pre-build bin).
    1. Выполнить `mkcert --install`
1. Сгенерировать сертификаты для сайтов в папке cert. Например:
    1. `cd certs`
    1. `mkcert myapp.localhost`
    1. `mkcert "*.myapp.localhost"`
    1. `cd -`
1. Выполнить `./setup.sh` для настройки и запуска traefic
1. Открыть http://localhost:8080


# Работа с сертификатам

Для быстрого обновления сертификатов `./refresh-certs.sh`.

При изменении сертификатов - просто перезапустить `./setup.sh`.

## Конфигурация контейнеров

```yml
services:
  webserver:
    networks:
      - default
      - traefik
    labels:
      traefik.enable: "true"
      traefik.http.routers.cargo.tls: "true"
      traefik.http.routers.cargo.rule: "HostRegexp(`myapp.localhost`, `{subdomain:.+}.myapp.localhost`)"
      traefik.http.routers.cargo.entrypoints: websecure
      traefik.http.services.cargo.loadbalancer.server.port: 80

networks:
  traefik:
    external: true
```

## Документация

https://doc.traefik.io/traefik/

## Todo

- [ ] Пример конфигурации для postgresql.
