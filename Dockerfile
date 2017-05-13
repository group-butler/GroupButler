FROM openresty/openresty:alpine-fat

WORKDIR /srv/app

RUN mkdir logs

RUN apk add --no-cache bash && mv /bin/sh /bin/sh.bak && ln -s /bin/bash /bin/sh

ARG ROCKS="luasocket luasec serpent i18n"
RUN for ROCK in $ROCKS; do luarocks install $ROCK; done

RUN rm /bin/sh && mv /bin/sh.bak /bin/sh

ARG OPM="pintsized/lua-resty-http leafo/pgmoon"
RUN opm install $OPM

ENTRYPOINT nginx -g 'daemon off;' -p `pwd`/ -c conf/"$ENV".conf

COPY lua lua
COPY conf conf
COPY i18n i18n
