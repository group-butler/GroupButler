FROM golang:alpine as healthchecker-builder
COPY healthchecker /go/src/healthchecker
RUN cd bin && go build healthchecker

FROM openresty/openresty:alpine-fat
EXPOSE 80
WORKDIR /usr/local/openresty/nginx

HEALTHCHECK --interval=3s --timeout=3s CMD ["healthchecker"] || exit 1

ARG DEPS_OPM="yangm97/lua-telegram-bot-api leafo/pgmoon"
RUN opm install $DEPS_OPM

COPY --from=healthchecker-builder /go/bin/healthchecker /usr/local/bin
COPY conf conf
COPY locales locales
COPY lua lua

ARG GB_COMMIT
ENV GB_COMMIT=$GB_COMMIT
