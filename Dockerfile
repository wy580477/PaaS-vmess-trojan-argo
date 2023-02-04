FROM alpine

COPY ./content /workdir/

RUN apk add --no-cache curl runit caddy jq bash tor \
    && chmod +x /workdir/service/*/run \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV SecretPATH=/mypath
ENV PASSWORD=password

EXPOSE 3000

ENTRYPOINT ["runsvdir", "-P", "/etc/service"]
