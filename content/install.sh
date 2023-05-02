set -e

# install sing-box
DIR_TMP="$(mktemp -d)"
EXEC=$(echo $RANDOM | md5sum | head -c 4)
busybox wget -O - 'https://github.com/SagerNet/sing-box/releases/download/v1.2.6/sing-box-1.2.6-linux-amd64.tar.gz' | busybox tar xz -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/sing-box*/sing-box /usr/bin/app${EXEC}
rm -rf ${DIR_TMP}

# install cloudflared
busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/download/2023.5.0/cloudflared-linux-amd64
chmod +x /usr/bin/argo 
