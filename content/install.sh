set -e
EXEC=$(echo $RANDOM | md5sum | head -c 4)
git clone https://github.com/SagerNet/sing-box
cd sing-box
export CGO_ENABLED=0
go build -trimpath -tags with_wireguard,with_clash_api,with_gvisor \
        -o /usr/bin/app${EXEC} \
        -ldflags "-s -w -buildid=" \
        ./cmd/sing-box
cd
rm -rf go sing-box

