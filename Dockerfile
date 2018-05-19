FROM yangm97/lua:5.2-alpine

WORKDIR /srv/app

CMD ["polling.lua"]

ARG DEPS_NATIVE="curl-dev"

ARG DEPS_ROCKS="luasec luasocket redis-lua lua-term serpent Lua-cURL"

RUN apk add --no-cache $DEPS_NATIVE && \
    for ROCK in $DEPS_ROCKS; do luarocks install $ROCK; done
		
RUN luarocks install lua-cjson 2.1.0-1

COPY . .
