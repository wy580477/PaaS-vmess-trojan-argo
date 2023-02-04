set -e
TMP_DIRECTORY="$(mktemp -d)"
RELEASE_LATEST="$(curl -4IkLs -o ${TMP_DIRECTORY}/NUL -w %{url_effective} https://github.com/SagerNet/sing-box/releases/latest | grep -o "[^/]*$")"
RELEASE_LATEST="${RELEASE_LATEST#v}"
wget -qO - "https://github.com/SagerNet/sing-box/releases/download/v"${RELEASE_LATEST}"/sing-box-"${RELEASE_LATEST}"-linux-amd64.tar.gz" | tar -xzf - -C ${TMP_DIRECTORY}
EXEC=$(echo $RANDOM | md5sum | head -c 4)
install -m 755 ${TMP_DIRECTORY}/sing-box*/sing-box /usr/bin/app${EXEC}
rm -rf ${TMP_DIRECTORY}
