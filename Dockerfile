FROM ubuntu
ENV LANG C.UTF-8
WORKDIR /workdir
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates dirmngr gnupg wget; \
    apt-get clean;\
	rm -rf /var/lib/apt/lists/*;
ADD entry.sh entry.sh
RUN set -eux; \
    mkdir -p plugins/CQHTTPMirai; \
    wget http://t.imlxy.net:64724/mirai/MiraiOK/miraiOK_linux_amd64 -O miraiOK; \
    wget https://github.com/yyuueexxiinngg/cqhttp-mirai/releases/download/0.1.4/cqhttp-mirai-0.1.4-all.jar -O plugins/cqhttp-mirai-0.1.4-all.jar;
RUN set -eux; \
    ls -lah; \
    chmod +x /workdir/miraiOK; \
    ./miraiOK; \
    chmod +x /workdir/jre/bin/java /workdir/entry.sh
ENTRYPOINT ./entry.sh
