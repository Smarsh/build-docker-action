FROM docker:stable

COPY entrypoint.sh /entrypoint.sh

CMD ["sh", "/entrypoint.sh"]