FROM debian:bullseye-slim

COPY ./content /workdir/

RUN apt-get update \
    && apt-get install -y ca-certificates runit jq libevent-2.1-7 bash busybox \
    && sh /workdir/install.sh \
    && rm -rf /var/lib/apt/lists/* /workdir/install.sh \
    && chmod +x /workdir/service/*/run \
    && ln -s /workdir/service/* /etc/service/

ENV PORT=3000
ENV SecretPATH=/mypath
ENV PASSWORD=password

EXPOSE 3000

ENTRYPOINT ["runsvdir", "/etc/service"]
