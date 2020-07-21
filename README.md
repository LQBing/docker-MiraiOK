# docker image for MiraiOK

## 参考

https://gitee.com/LXY1226/MiraiOK

https://yobot.win/install/Linux-cqhttp-mirai/

## github地址

https://github.com/LQBing/docker-MiraiOK

## 镜像仓库

海外： lqbing/miraiok

```shell script
docker pull lqbing/miraiok
```

国内： registry.cn-hongkong.aliyuncs.com/lqbing/miraiok

```shell script
docker pull registry.cn-hongkong.aliyuncs.com/lqbing/miraiok
```


## 使用说明

PS： 第一次使用往往会要求输入验证码，有时候还会给个网址复制链接然后手机QQ扫描二维码验证。所以第一次不能直接挂后台，运行需要`docker run -it`运行来通过验证程序。

有两种方式启动：

[1 使用.env文件配置QQ账号密码等信息快速运行，但是只能单账号运行](#env)

[2 挂载配置文件的方式运行（多个用户的情况下用环境变量无法满足需求，可以用挂载配置文件的方式达到目的）](#mount)

## <span id="env">使用.env文件带入参数运行</span>

创建.env，然后修改其中内容

```shell script
cp .env.example .env 
vi .env
```

第一次运行（第一次使用往往会要求输入验证码，有时候还会给个网址复制链接然后手机QQ扫描二维码验证。所以第一次不能直接挂后台，运行需要`docker run -it`运行来通过验证程序。）

QQ账号在当前设备第一次运行需要输入验证码（device.json文件不能丢，否则会造成要重新输入验证码的问题）。如果几次不对（反正我肉眼凡胎没几次对的）会在提示在`/tmp `目录下生成验证码图片，这时候挂载出来的`/tmp`目录就有用了。之后一些账号可能会再提示一长串的连接地址，复制出来浏览器打开，然后手机同账号QQ扫描二维码通过验证后再回车才能完成登录过程。
```shell script
docker run --rm -it --name miraiok --env-file .env -v $(pwd)/tmp:/tmp lqbing/miraiok
```

上面的步骤完成，并且屏幕有输出QQ的聊天记录的话就意味着验证通过了，这时候`ctrl+c`退出，下面有两个选择，一个是`docker run`的方式启动，一种是`docker-compose`的方式启动：

### docker run

完成了上述步骤之后如果要直接挂到后台运行的话可以运行下面的命令（必须带`-t`，否则会出现账号文件载入失败问题）：

```shell script
docker run -t -d --name miraiok --restart=always --env-file .env -v $(pwd)/log:/log lqbing/miraiok
```

### docker-compose

如果是要用docker-compose启动的话可以用`docker-compose up -d`命令启动。docker-compose.yml文件内容如下：

```yaml
version: "3"
services:
  miraiok:
    image: lqbing/miraiok
    restart: always
    env_file: .env
    volumes:
      - ./log:/workdir/log
    stdin_open: true
    tty: true

```

### <span id="mount">挂载配置文件的方式运行</span>

PS：注意`config.txt`,`setting.yml`,`device.json`三个文件是否存在,如果不存在可能造成运行问题。

创建配置文件：

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
```

然后配置文件具体怎么修改参考[配置文件说明](#config)

第一次运行：
```bash
docker run --rm -it --name miraiok -v $(pwd)/config.txt:/workdir/config.txt -v $(pwd)/setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml -v $(pwd)/device.json:/workdir/device.json -v $(pwd)/log:/workdir/log -v $(pwd)/tmp:/tmp lqbing/miraiok
```
上面的步骤完成，并且屏幕有输出QQ的聊天记录的话就意味着验证通过了，这时候`ctrl+c`退出，下面有两个选择，一个是`docker run`的方式启动，一种是`docker-compose`的方式启动：

### docker run

如果要用docker run启动的话运行下面命令即可：

```bash
docker run -t -d --name miraiok -v $(pwd)/config.txt:/workdir/config.txt -v $(pwd)/setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml -v $(pwd)/device.json:/workdir/device.json -v $(pwd)/log:/workdir/log -v $(pwd)/tmp:/tmp lqbing/miraiok
```
### docker-compose

如果要用docker-compose启动的话可以用`docker-compose up -d`命令启动。docker-compose.yml文件内容如下：

```yaml
version: "3"
services:
  miraiok:
    image: lqbing/miraiok
    restart: always
    volumes:
      - ./config.txt:/workdir/config.txt
      - ./setting.yml:/workdir/plugins/CQHTTPMirai/setting.yml
      - ./device.json:/workdir/device.json
      - ./log:/workdir/log
    stdin_open: true
    tty: true
```

查看是否还活着：

```shell script
docker ps -a | grep miraiok
```

查看日志：

```shell script
docker logs --tail 100 -f miraiok
```

干掉：

```shell script
docker stop miraiok
docker rm miraiok
```


## <a id="config">配置文件说明</a>

### config.txt

用于指定登陆的QQ账号和密码以及给指定QQ发信息（一定要有第一排的`----------`，否则会造成读取失败，为啥请问miraiOK的作者，这里只是个镜像封装）

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

## 构建

```bash
cd build
./miraiOK
docker build -t lqbing/miraiok .
```

PS：注意如果自己运行docker run的话哪怕是-d后台运行也要加-it参数，否则会造成无法登陆的问题

### docker-compose

```bash
docker-compose up -d
```

PS: 注意`docker-compose.yml`中的`stdin_open`和`tty`参数，否则会造成无法登陆的问题


## 文件源

    http://t.imlxy.net:64724/mirai/MiraiOK/miraiOK_linux_amd64 
    https://github.com/yyuueexxiinngg/cqhttp-mirai/releases/download/0.1.4/cqhttp-mirai-0.1.4-all.jar 
