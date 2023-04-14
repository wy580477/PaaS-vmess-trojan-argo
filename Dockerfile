FROM alpine

COPY ./content /workdir/

RUN apk add --no-cache caddy runit jq tor bash \
    && sh /workdir/install.sh \
    && rm /workdir/install.sh \
    && chmod +x /workdir/service/*/run \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV SecretPATH=/mypath
ENV PASSWORD=password
ENV CLASH_MODE=rule

EXPOSE 3000

ENTRYPOINT ["runsvdir", "/etc/service"]
