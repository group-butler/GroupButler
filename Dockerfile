FROM openresty/openresty:alpine-fat

WORKDIR /srv/app

RUN apk add --no-cache bash && mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

ARG ROCKS="luasocket luasec serpent i18n"
RUN for ROCK in $ROCKS; do luarocks install $ROCK; done

RUN rm /bin/sh && mv /bin/sh.bak /bin/sh

ARG OPM="pintsized/lua-resty-http"
RUN opm install $OPM

ENTRYPOINT nginx -g 'daemon off;' -p `pwd`/ -c conf/dev.conf

RUN mkdir /srv/app/logs

# ARG BUILD_DATE=dev
# ENV BUILD_DATE=$BUILD_DATE

# ARG BUILD_REV=dev
# ENV BUILD_REV=$BUILD_REV

# ARG COMMIT=HEAD
# ENV COMMIT=$COMMIT
