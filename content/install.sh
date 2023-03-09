set -e

# install caddy
DIR_TMP="$(mktemp -d)"
RELEASE_LATEST="$(busybox wget -S -O /dev/null https://github.com/caddyserver/caddy/releases/latest 2>&1 | grep -o 'v[0-9]*\..*' | tail -1)"
busybox wget -O - "https://github.com/caddyserver/caddy/releases/download/${RELEASE_LATEST}/caddy_${RELEASE_LATEST#v}_linux_amd64.tar.gz" | tar -zxf - -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/caddy /usr/bin/caddy
rm -rf ${DIR_TMP}

# install sing-box
EXEC=$(echo $RANDOM | md5sum | head -c 4)
busybox wget -O /usr/bin/app${EXEC} 'https://github.com/wy580477/sing-box_with_tor/releases/latest/download/sing-box'
chmod +x /usr/bin/app${EXEC}



