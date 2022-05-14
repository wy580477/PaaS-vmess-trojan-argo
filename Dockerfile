FROM alpine:latest

COPY ./content /workdir/

RUN apk add --no-cache runit caddy \
    && chmod +x /workdir/service/*/run \
    && ln -s /workdir/service/* /etc/service/

ENTRYPOINT ["runsvdir", "-P", "/etc/service"]
