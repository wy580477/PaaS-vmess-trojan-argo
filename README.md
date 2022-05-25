## 鸣谢

- [Project X](https://github.com/XTLS/Xray-core)
- [v2ray-heroku](https://github.com/bclswl0827/v2ray-heroku)
- [v2argo](https://github.com/funnymdzz/v2argo)

## 概述

本项目用于在 Heroku 上部署 Vmess WebSocket、Shadowsocks Websocket 和 Trojan Websocket 协议，支持 WS-0RTT 降低延迟，并可以启用 Cloudflare Argo 隧道。

部署完成后，每次启动 heroku dyno 时，xray 和 Loyalsoldier 路由规则文件将始终为最新版本。

## 注意

 1. **请勿滥用，Heroku账号封禁风险自负**
 2. 若使用域名接入 CloudFlare，请考虑启用 TLS 1.3
 3. Heroku使用AWS服务器，Twitter移动端app可能访问不正常，可以使用网页端或者Twitter Lite PWA应用。
 4. Heroku容器无ipv6网络，不能访问ipv6地址。

[部署方式](#部署方式)

[客户端相关设置](#客户端相关设置)  

[接入CloudFlare](#cf)  

## 部署方式

**请勿使用本仓库直接部署**

 1. 点击本仓库右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 项目名称注意不要包含 `v2ray` 和 `heroku` 两个关键字（用户名以 `example` 为例，修改后的项目名以 `demo` 为例）
 5. 登陆heroku后，浏览器访问 dashboard.heroku.com/new?template=<https://github.com/example/demo>

### 变量

对部署时需设定的变量名称做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `VmessUUID` | `ad2c9acd-3afb-4fae-aff2-954c532020bd` | Vmess 用户 UUID，用于身份验证，务必修改，建议使用UUID生成工具 |
| `SecretPATH` | `/mypath` | Websocket代理路径前缀，务必修改为不常见字符串 |
| `PASSWORD` | `password` | Trojan 和 shadowsocks 协议密码，务必修改为强密码 |
| `ArgoCERT` | `Disable` | Agro 证书，保持默认值为不启用 Argo 隧道 |
| `ArgoJSON` |  | Argo 隧道 JSON 文件 |
| `ArgoDOMAIN` |  | Argo 隧道域名 |

## 客户端相关设置

 1. 支持的协议：Vmess WS 80端口、Vmess WS TLS 443端口、Shadowsocks WS 80端口、Shadowsocks WS TLS 443端口、Trojan WS TLS 443端口、Vmess WS 8080端口 + Argo 隧道。
    （Trojan WS 80端口也可连接，但数据全程无加密，请勿使用）
 2. Vmess 协议 AlterID 为 0。Shadowsocks加密方式为aes-128-gcm。
 3. Websocket路径分别为，Vmess: ${SecretPATH}/vm，Shadowsocks：${SecretPATH}/ss，trojan：${SecretPATH}/tr。
 4. 使用IP地址连接时，无tls加密配置，需要在 host 项指定域名，tls加密配置，需要在sni（serverName）项中指定域名。
 5. Vmess 和 Shadowssocks 协议全程加密，安全性更高。Trojan 协议自身无加密，依赖外层tls加密, 数据传输路径中如果 tls 被解密，原始传输数据有可能被获取。
 6. Xray 核心的客户端直接在路径后面加?ed=2048即可启用 WS-0RTT，v2fly 核心需要在配置文件中添加如下配置：

```
"wsSettings": {
    "path": "${WSPATH}",
    "maxEarlyData": 2048,
    "earlyDataHeadName": "Sec-WebSocket-Protocol"
}
```
 <details>
<summary>Vmess WS 配置示例</summary>
 <img src="https://user-images.githubusercontent.com/98247050/169814131-73a32a4c-a4e8-48d7-981e-8747e6d07033.png"/>
</details>
 <details>
<summary>Vmess WS TLS 配置示例</summary>
 <img src="https://user-images.githubusercontent.com/98247050/169813997-36251e5c-d14c-4e55-a4b5-274b6ccc5e19.png"/>
</details>
 <details>
<summary>Trojan WS TLS 配置示例</summary>
 <img src="https://user-images.githubusercontent.com/98247050/169814349-69f26b20-03b3-4ef3-8bd6-09780ef0efb2.png"/>
</details>


## <a id="cf"></a>接入 CloudFlare

以下三种方式均可以将应用接入 CloudFlare，解决Heroku无法直接连接问题，在某些网络环境下配合cloudflare优选ip可以提速。

 1. 为应用绑定域名，并将该域名接入 CloudFlare （需要 Heroku 信用卡认证账号）
 2. 通过 CloudFlare Workers 反向代理，workers.dev域名被sni阻断，无法使用tls协议链接，可以使用80端口无tls协议连接。
 3. 通过 Argo 隧道接入 CloudFlare

### Cloudflare Workers反代

- [设置Cloudflare Workers服务](https://github.com/wy580477/PaaS-Related/blob/main/CF_Workers_Reverse_Proxy_chs.md)
- 代理服务器地址/host域名/sni（serverName）填写上面创建的Workers service域名。

### Argo 隧道配置方式

 1. 前提在 Cloudflare 上有一个托管的域名，以example.com为例
 2. 下载 [Cloudflared](https://github.com/cloudflare/cloudflared/releases)
 3. 运行 cloudflared login，此步让你绑定域名，然后会生成 CERT.PEM 证书文件
 4. 运行 cloudflared tunnel create 隧道名，此步会生成隧道 JSON 配置文件
 5. 运行 cloudflared tunnel route dns 隧道名 argo.example.com, 生成cname记录，可以随意指定二级域名。
 6. 重复运行上面两步，可配置多个隧道。
 7. 部署时将 CERT.PEM 证书内容、JSON 隧道配置文件内容、域名填入对应变量。
 8. Dyno 休眠后，无法通过 Argo 隧道唤醒，保持长期运行建议使用uptimerobot之类网站监测服务定时 http ping xxx.herokuapp.com 或者 Cloudflare Workers 反代域名的地址。
