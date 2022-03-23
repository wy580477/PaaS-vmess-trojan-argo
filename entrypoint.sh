#!/bin/sh

# Global variables
DIR_CONFIG="/etc/config"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Config & Run Caddy
cat << EOF > /etc/caddy/Caddyfile
:$PORT
respond / 200
@websockets {
        header Connection *Upgrade*
        header Upgrade websocket
        path_regexp ${VmessPATH}.*
}
reverse_proxy @websockets 127.0.0.1:8080
@websockets-tr {
        header Connection *Upgrade*
        header Upgrade websocket
        path_regexp ${TrojanPATH}.*
}
reverse_proxy @websockets-tr 127.0.0.1:10088
EOF

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &

# Creat config dir
mkdir -p ${DIR_CONFIG}

# Config & Run argo tunnel
if [ "${ArgoCERT}" = "CERT" ]; then
    echo skip 
else
    wget -O ${DIR_CONFIG}/cert.pem $ArgoCERT
    echo $ArgoJSON > ${DIR_CONFIG}/argo.json
    ARGOID="$(jq .TunnelID ${DIR_CONFIG}/argo.json | sed 's/\"//g')"
    cat << EOF > ${DIR_CONFIG}/argo.yaml
    tunnel: ${ARGOID}
    credentials-file: ${DIR_CONFIG}/argo.json
    ingress:
      - hostname: ${ArgoDOMAIN}
        service: http://localhost:8080
      - service: http_status:404
EOF
wget --no-check-certificate -O argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod 755 argo
./argo --loglevel info --origincert ${DIR_CONFIG}/cert.pem tunnel -config ${DIR_CONFIG}/argo.yaml run ${ARGOID} &
fi    

# Write Ray configuration
cat << EOF > ${DIR_CONFIG}/ray.yaml
log:
  loglevel: info
dns:
  servers:
  - https+local://8.8.8.8/dns-query
inbounds:
- port: 8080
  protocol: vmess
  settings:
    clients:
    - id: "${VmessUUID}"
  streamSettings:
    network: ws
    wsSettings:
      path: "${VmessPATH}"
  sniffing:
    enabled: true
    destOverride:
    - http
    - tls
- port: 10088
  protocol: trojan
  settings:
    clients:
    - password: "${TrojanPassword}"
  streamSettings:
    network: ws
    wsSettings:
      path: "${TrojanPATH}"
  sniffing:
    enabled: true
    destOverride:
    - http
    - tls
outbounds:
- protocol: freedom
  tag: direct
  settings:
    domainStrategy: UseIPv4
EOF

# Get Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL https://github.com/XTLS/Xray-core/releases/latestest/download/Xray-linux-64.zip -o ${DIR_TMP}/ray_dist.zip
busybox unzip ${DIR_TMP}/ray_dist.zip -d ${DIR_TMP}

# Install Ray
install -m 755 ${DIR_TMP}/xray ${DIR_RUNTIME}/ray
rm -rf ${DIR_TMP}
curl --retry 10 --retry-max-time 60 https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -o ${DIR_RUNTIME}/geoip.dat
curl --retry 10 --retry-max-time 60 https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -o ${DIR_RUNTIME}/geosite.dat

# Run Ray
${DIR_RUNTIME}/ray -config=${DIR_CONFIG}/ray.yaml
