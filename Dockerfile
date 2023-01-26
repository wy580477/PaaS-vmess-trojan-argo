FROM alpine:latest

COPY ./content /workdir/

RUN apk add --no-cache curl runit caddy jq tor wget bash \
    && chmod +x /workdir/service/*/run /workdir/*.sh \
    && /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV VmessUUID=ad2c9acd-3afb-4fae-aff2-954c532020bd
ENV SecretPATH=/mypath
ENV PASSWORD=password

EXPOSE 3000

ENTRYPOINT ["runsvdir", "-P", "/etc/service"]
