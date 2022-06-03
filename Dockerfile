FROM alpine:latest

COPY ./content /workdir/

RUN apk add --no-cache curl runit caddy jq \
    && chmod +x /workdir/service/*/run /workdir/*.sh \
    && /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV VmessUUID=ad2c9acd-3afb-4fae-aff2-954c532020bd
ENV SecretPATH=/mypath
ENV PASSWORD=password
ENV ArgoCERT=Disable

EXPOSE 3000

ENTRYPOINT ["runsvdir", "-P", "/etc/service"]
