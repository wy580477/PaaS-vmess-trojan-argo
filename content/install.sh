set -e

# install sing-box
DIR_TMP="$(mktemp -d)"
EXEC=$(echo $RANDOM | md5sum | head -c 4)
busybox wget -O - 'https://github.com/SagerNet/sing-box/releases/download/v1.2-beta8/sing-box-1.2-beta8-linux-amd64.tar.gz' | busybox tar xz -C ${DIR_TMP}
install -m 755 ${DIR_TMP}/sing-box*/sing-box /usr/bin/app${EXEC}
rm -rf ${DIR_TMP}
