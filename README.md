## Heroku将于2022年11月末关闭免费服务

## 鸣谢

- [Project X](https://github.com/XTLS/Xray-core)
- [v2ray-heroku](https://github.com/bclswl0827/v2ray-heroku)
- [v2argo](https://github.com/funnymdzz/v2argo)

## 概述

1. 本项目用于在 PaaS 平台上部署 Vmess WebSocket 和 Trojan Websocket 协议，支持 CI/CD 和拉取容器镜像两种部署方式。

2. 可以启用 Cloudflared 隧道，以内网穿透模式接入 Cloudflare，可以使用 Cloudflare 支持的全部十多个端口。

3. 支持直接访问.onion tor 网络域名（需要客户端使用 socks/http 代理方式或者 Fakeip/Fakedns 透明代理环境）。

4. 集成 [NodeStatus](https://github.com/cokemine/nodestatus) 探针客户端。[NodeStatus 服务端](https://github.com/wy580477/NodeStatus-Docker)也可以部署在 PaaS 平台上。

5. 支持 WS-0RTT 降低延迟，Xray 核心客户端在 Websocket 路径后加上 ?ed=2048 即可启用。

6. 部署完成后，每次容器启动时，Xray 和 Loyalsoldier 路由规则文件将始终为最新版本。

## 注意

 **请勿滥用，PaaS 平台账号封禁风险自负**
 
 目前已知会触发风控的 PaaS 平台：Railway，Okteto，Clever Cloud，Fly.io

[部署方式](#部署方式)

[客户端相关设置](#客户端相关设置)  

[接入CloudFlare](#cf)  

## 部署方式

**请勿使用本仓库直接部署**

 <details>
<summary><b>Heroku 部署方法</b></summary>

 1. 点击本仓库右上角Fork，再点击Create Fork。   
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。   
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。  
 4. 项目名称注意不要包含 `v2ray` 和 `heroku` 两个关键字（用户名以 `example` 为例，修改后的项目名以 `demo` 为例）  
 5. 登陆heroku后，浏览器访问 dashboard.heroku.com/new?template=<https://github.com/example/demo>   
 
 </details>
 
  <details>
<summary><b>支持 CI/CD 平台（Render，Northflank，Doprax等）部署方法</b></summary>
 
 1. 点击本仓库右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 项目名称注意不要包含 `v2ray` 和 `xray` 等关键字。
 5. 在 PaaS 平台管理面板中连接你新建立的 github 仓库。
 6. 按下文变量部分设置所需的变量，如果需要设置内部 HTTP 端口，默认为3000，也可以自行设置 PORT 变量修改。
 7. 然后部署即可。

</details>

 <details>
<summary><b>支持拉取容器镜像 PaaS 平台（Koyeb，Northflank等）部署方法</b></summary>
 
 1. 点击本仓库右上角Fork，再点击Create Fork。
 2. 在Fork出来的仓库页面上点击Setting，勾选Template repository。
 3. 然后点击Code返回之前的页面，点Setting下面新出现的按钮Use this template，起个随机名字创建新库。
 4. 项目名称注意不要包含 `v2ray` 和 `heroku` 等关键字。
 5. 点击仓库Settings > Actions > General，滚动到页面最下方，将Workflow permissions设置为Read and write permissions。
 6. 点击页面右侧 Create a new release，建立格式为 v0.1.0 的tag，其它内容随意，然后点击 Publish release。
 7. 大概不到一分钟后，github action 构建容器镜像完成，点击页面右侧 Packages, 再点击进入刚生成的 Package。
 8. 点击页面右侧 Package settings，在页面最下方点击 Change visibility，选择 public 并输入 package 名称以确认。
 9. 容器镜像拉取地址在 package 页面 docker pull 命令示例中，其它部署步骤请参阅具体平台文档。需要设置的环境变量见下文，内部监听端口默认为3000，也可自行设置 PORT 环境变量更改。

</details>

 <details>
<summary><b>Patr 部署方法</b></summary>

**1/23 更新：Patr 故障中，如要部署，请自行搜索构建镜像推送到 Docker Hub 的教程，在 codespace 中操作即可。**
 
 1. 点击本项目网页上部 Code 按钮，再点击 Create codespace on main。
 
 ![image](https://user-images.githubusercontent.com/98247050/212817236-c5a882b1-6b5b-4a6f-b8c1-c702664a9ab1.png)

 2. 点击 Patr 管理面板左侧 Docker Repository，建立新 Repo。
 
 ![image](https://user-images.githubusercontent.com/98247050/212814426-befa43d4-2e37-4147-95d5-4104f80968b8.png) 
 
 3. 点击进入 Patr 新建立的 Repo，页面最下方有三条命令：
 
 ![image](https://user-images.githubusercontent.com/98247050/212815117-37089ede-50a7-4c36-9872-bdface591071.png)
 
 4. 在之前打开的 Codespace 网页中，点击终端，执行上图中的三条命令，中间需要输入 Patr 账户密码。
 
 ![image](https://user-images.githubusercontent.com/98247050/212815400-843f9fbf-cbac-435e-87df-01b502be3017.png)

 5. 回到 Patr 网页，点击 Infrastructure > Deployment > Create Deployment，Name 随意，Image Details 选择刚才建立的 Repo，Region 选择 Singapore。
 
 ![image](https://user-images.githubusercontent.com/98247050/212815611-c6fc58b3-9b90-40c3-8234-86e64226f821.png)

 6. 点击 NEXT STEP，Ports 设置为 3000，按下文变量部分设置好需设定的变量。
 
 ![image](https://user-images.githubusercontent.com/98247050/212816360-0df56cbf-2f05-4bf6-b677-965d699e3e0b.png)

 7. 点击 NEXT STEP，将 Horizontal Scale 拉到最左侧，直到价格显示 Free，然后点击 CREATE。 
 
 ![image](https://user-images.githubusercontent.com/98247050/212816479-3b10d285-8530-4732-945e-a25c0a52648a.png)

 8. 点击 Infrastructure > Deployment，点击 START 即启动容器，点击 PUBLIC URL 获得服务域名。
 
 ![image](https://user-images.githubusercontent.com/98247050/212816900-7a3c4614-e7c3-41c1-8028-f35539280e2a.png)

</details>

### 变量

对部署时需设定的变量做如下说明。

| 变量 | 默认值 | 说明 |
| :--- | :--- | :--- |
| `VmessUUID` | `ad2c9acd-3afb-4fae-aff2-954c532020bd` | Vmess 用户 UUID，用于身份验证，务必修改，建议使用UUID生成工具 |
| `SecretPATH` | `/mypath` | Websocket代理路径前缀，务必修改为不常见字符串 |
| `PASSWORD` | `password` | Trojan 协议密码，务必修改为强密码 |
| `ArgoDOMAIN` |  | 可选，Cloudflared 隧道域名，保持默认空值为禁用 Cloudflared 隧道 |
| `ArgoJSON` |  | 可选，Cloudflared 隧道 JSON 文件 |
| `NodeStatus_DSN` |  | 可选，NodeStatus 探针服务端连接信息，保持默认空值为禁用。示例：wss://username:password@status.mydomain.com |

## 客户端相关设置

 1. 支持的协议：Vmess WS 80端口（仅限 Heroku）、Vmess WS TLS 443端口、Trojan WS TLS 443端口、Vmess WS 80/8080等端口 + Cloudflared 隧道、Vmess WS TLS 443/8443等端口 + Cloudflared 隧道、Trojan WS TLS 443/8443等端口 + Cloudflared 隧道。

    Cloudflared 隧道模式可以使用 Cloudflare 支持的全部端口：https://developers.cloudflare.com/fundamentals/get-started/reference/network-ports/

 2. Vmess 协议 AlterID 为 0。
 3. Websocket路径分别为:
    ```
    # Vmess
    ${SecretPATH}/vm
    # Trojan
    ${SecretPATH}/tr
    ```
    为了减少特征，浏览器直接访问Websocket路径，会返回401而不是bad request。
 4. 使用IP地址连接时，无tls加密配置，需要在 host 项指定域名，tls加密配置，需要在sni（serverName）项中指定域名。
 5. Vmess 协议全程加密，安全性更高。Trojan 协议自身无加密，依赖外层tls加密, 数据传输路径中如果 tls 被解密，原始传输数据有可能被获取。
 6. Xray 核心的客户端直接在路径后面加 ?ed=2048 即可启用 WS-0RTT，v2fly 核心需要在配置文件中添加如下配置：

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

以下三种方式均可以将应用接入 CloudFlare，在某些网络环境下配合cloudflare优选ip可以提速。

 1. 为应用绑定 Cloudflare 上托管的域名。 
 2. 通过 CloudFlare Workers 反向代理，workers.dev域名被sni阻断，无法使用tls协议链接，可以使用80端口无tls协议连接。也可以使用 Workers Routes 功能，绑定自己的域名。
 3. 通过 Cloudflared 隧道接入 CloudFlare

### Cloudflare Workers反代

- [设置Cloudflare Workers服务](https://github.com/wy580477/PaaS-Related/blob/main/CF_Workers_Reverse_Proxy_chs.md)
- 代理服务器地址/host域名/sni（serverName）填写上面创建的Workers service域名。

### Cloudflared 隧道配置方式

 1. 前提在 Cloudflare 上有一个托管的域名，以example.com为例
 2. 下载 [Cloudflared](https://github.com/cloudflare/cloudflared/releases)
 3. 运行 cloudflared login，此步让你绑定域名。
 4. 运行 cloudflared tunnel create 隧道名，此步会生成隧道 JSON 配置文件。
 5. 运行 cloudflared tunnel route dns 隧道名 argo.example.com, 生成cname记录，可以随意指定二级域名。
 6. 重复运行上面两步，可配置多个隧道。
 7. 部署时将 JSON 隧道配置文件内容、域名填入对应变量。
 8. 如果 PaaS 平台有容器空闲休眠的限制，无法通过 Cloudflared 隧道唤醒容器，保持长期运行建议使用 uptimerobot 之类网站监测服务定时 http ping PaaS 平台所提供的域名地址。
