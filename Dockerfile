FROM alpinelinux/docker-cli:latest

RUN apk update --no-cache && apk add gettext bash

COPY entrypoint.sh /entrypoint.sh

COPY credhub /usr/bin/

RUN chmod +x /usr/bin/credhub

CMD ["sh", "/entrypoint.sh"]