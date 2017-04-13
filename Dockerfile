FROM ubuntu:16.04

WORKDIR /srv/telebots

COPY .deps .

# TODO: migrar dependências para rockspec e parar de usar bash
RUN mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

RUN . ./.deps && \
    apt-get update && apt-get install -y $NATIVE ca-certificates gcc --no-install-recommends && \
    git clone http://github.com/keplerproject/luarocks && cd luarocks && ./configure --lua-version=$LUA && make build && make install && for ROCK in $ROCKS; do luarocks install $ROCK; done && \
    apt-get remove -y git gcc make unzip && apt-get autoremove -y && rm -rf luarocks /var/lib/apt/lists/* /tmp/* /root/.cache

RUN rm /bin/sh && mv /bin/sh.bak /bin/sh

ENTRYPOINT ["lua", "bot.lua"]

ARG BUILD_DATE=Hoje
ENV BUILD_DATE=$BUILD_DATE

ARG BUILD_REV=dev
ENV BUILD_REV=$BUILD_REV

ARG COMMIT=HEAD
ENV COMMIT=$COMMIT

COPY . .
