set -e

# install sing-box
DIR_TMP="$(mktemp -d)"
EXEC=$(echo $RANDOM | md5sum | head -c 4)
busybox wget -O - 'https://github.com/SagerNet/sing-box/releases/download/v1.3.0/sing-box-1.3.0-linux-amd64.tar.gz' | busybox tar xz -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/sing-box*/sing-box /usr/bin/app${EXEC}
rm -rf ${DIR_TMP}

# install cloudflared
busybox wget -qO /usr/bin/argo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /usr/bin/argo 

# generate warp config
busybox wget -qO /usr/bin/warp-reg https://github.com/badafans/warp-reg/releases/download/v1.0/main-linux-amd64
chmod +x /usr/bin/warp-reg
/usr/bin/warp-reg > /etc/warp.conf
rm /usr/bin/warp-reg

WG_PRIVATE_KEY=$(grep private_key /etc/warp.conf | sed "s|.*: ||")
WG_PEER_PUBLIC_KEY=$(grep public_key /etc/warp.conf | sed "s|.*: ||")
WG_IP6_ADDR=$(grep v6 /etc/warp.conf | sed "s|.*: ||")
WG_RESERVED=$(grep reserved /etc/warp.conf | sed "s|.*: ||")
if [[ ! "${WG_RESERVED}" =~ , ]]; then
    WG_RESERVED=\"${WG_RESERVED}\"
fi

sed -i "s|WG_PRIVATE_KEY|${WG_PRIVATE_KEY}|;s|WG_PEER_PUBLIC_KEY|${WG_PEER_PUBLIC_KEY}|;s|fd00::1|${WG_IP6_ADDR}|;s|\[0, 0, 0\]|${WG_RESERVED}|" /workdir/config-wg.json
