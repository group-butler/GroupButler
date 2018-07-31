FROM yangm97/lua:5.1-alpine

WORKDIR /srv/app

CMD ["polling.lua"]

ARG DEPS_NATIVE="curl-dev"

ARG DEPS_ROCKS="redis-lua lua-term serpent lua-cjson Lua-cURL telegram-bot-api"

RUN apk add --no-cache $DEPS_NATIVE && \
    for ROCK in $DEPS_ROCKS; do luarocks install $ROCK; done

COPY locales locales
COPY lua lua
COPY polling.lua .

ARG GB_COMMIT
ENV GB_COMMIT=$GB_COMMIT
