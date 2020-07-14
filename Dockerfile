FROM alpinelinux/docker-cli:latest

RUN apk update --no-cache && apk wget add gettext bash

COPY entrypoint.sh /entrypoint.sh

COPY credhub /usr/bin/

RUN chmod +x /usr/bin/credhub

RUN  wget -O pivnet https://github.com/pivotal-cf/pivnet-cli/releases/download/v1.0.4/pivnet-linux-amd64-1.0.4 && \
    chmod +x pivnet && \
    mv pivnet /usr/local/bin/

CMD ["sh", "/entrypoint.sh"]