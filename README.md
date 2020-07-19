# docker image for MiraiOK

## 参考

https://gitee.com/LXY1226/MiraiOK

https://yobot.win/install/Linux-cqhttp-mirai/

## 文件源

    http://t.imlxy.net:64724/mirai/MiraiOK/miraiOK_linux_amd64 
    https://github.com/yyuueexxiinngg/cqhttp-mirai/releases/download/0.1.4/cqhttp-mirai-0.1.4-all.jar 

## 配置文件

### config.txt

用于指定登陆的QQ账号和密码以及给指定QQ发信息

```txt
----------
login 123456789 ppaasswwdd
say 987654321 MiraiOK_123456789_published!

```

### plugins/CQHTTPMirai/setting.yml

用于指定信息转发给哪个bot地址

```yaml
# 要进行配置的QQ号 (Mirai支持多帐号登录, 故需要对每个帐号进行单独设置)
"1234567890":
  ws_reverse:
    enable: true
    postMessageFormat: string
    reverseHost: 127.0.0.1
    reversePort: 9222
    reversePath: /ws/
    accessToken: null
    reconnectInterval: 3000
# 详细说明请参考 https://github.com/yyuueexxiinngg/cqhttp-mirai
```

### device.json

在正常登录后会生成。猜测是用于记录设备参数的，未验证。

## build

```bash
cd build
./miraiOK
docker build -t lqbing/miraiok .
```

## 运行

PS：注意`config.txt`,`setting.yml`,`device.json`三个文件是否存在,如果不存在可能造成运行问题。QQ账号密码写入到

```bash
./run.sh
```

### docker run

```bash
if [ ! -f "config.txt" ]; then
  cp config.txt.example config.txt
fi
if [ ! -f "setting.yml" ]; then
  cp setting.yml.example setting.yml
fi
if [ ! -f "device.json" ]; then
  cp device.json.example device.json
fi
docker run --rm -it --name miraiok -v $(pwd)/config.txt:/workdir/config.txt -v $(pwd)/setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml -v $(pwd)/device.json:/workdir/device.json -v $(pwd)/log:/workdir/log lqbing/miraiok
```

PS：注意如果自己运行docker run的话哪怕是-d后台运行也要加-it参数，否则会造成无法登陆的问题

### docker-compose

```bash
docker-compose up -d
```

PS: 注意`docker-compose.yml`中的`stdin_open`和`tty`参数，否则会造成无法登陆的问题
