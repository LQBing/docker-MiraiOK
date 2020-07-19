FROM ubuntu
ENV LANG C.UTF-8
WORKDIR /workdir
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates dirmngr gnupg wget; \
	rm -rf /var/lib/apt/lists/*; \
    mkdir -p plugins/CQHTTPMirai; \
    wget http://t.imlxy.net:64724/mirai/MiraiOK/miraiOK_linux_amd64 -O miraiOK; \
    chmod +x miraiOK; \
    cd plugins; \
    wget https://github.com/yyuueexxiinngg/cqhttp-mirai/releases/download/0.1.4/cqhttp-mirai-0.1.4-all.jar; \
    cd ..; \
    ./miraiOK; \
    chmod +x /workdir/jre/bin/java
ENTRYPOINT ./miraiOK 
