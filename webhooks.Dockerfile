FROM golang:alpine as healthchecker-builder
COPY healthchecker /go/src/healthchecker
RUN cd bin && go build healthchecker

FROM openresty/openresty:alpine-fat
EXPOSE 80
WORKDIR /srv/app

HEALTHCHECK --interval=3s --timeout=3s CMD ["healthchecker"] || exit 1
ENTRYPOINT nginx -p `pwd` -c conf/conf.conf

ARG DEPS_NATIVE="curl-dev openssl-dev git"
ARG DEPS_OPM="yangm97/lua-telegram-bot-api pintsized/lua-resty-http"
ARG DEPS_ROCKS="redis-lua serpent Lua-cURL"

RUN mkdir logs && \
    apk add --no-cache $DEPS_NATIVE && \
    opm install $DEPS_OPM && \
    for ROCK in $DEPS_ROCKS; do luarocks install $ROCK; done

COPY --from=healthchecker-builder /go/bin/healthchecker /usr/local/bin
COPY . .
