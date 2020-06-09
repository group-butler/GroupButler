FROM yangm97/lua:5.1-alpine

WORKDIR /srv/app

CMD ["polling.lua"]

RUN apk add --no-cache outils-md5

ARG DEPS_ROCKS="telegram-bot-api pgmoon lua-resty-socket"

RUN for ROCK in $DEPS_ROCKS; do luarocks install $ROCK; done

COPY locales locales
COPY lua lua
COPY polling.lua .

ARG GB_COMMIT
ENV GB_COMMIT=$GB_COMMIT
