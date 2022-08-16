FROM alpine:3.12

ENV TZ=Asia/Shanghai
ENV LANG=C.UTF-8 BGMI_PATH="/bgmi/conf/bgmi"
ENV PUID=1000
ENV PGID=1000
## true 和 false
ENV TRANSMISSION=true
## true 和 false
ENV TRANSMISSION_WEB_CONTROL=true
ENV BGMI_SOURCE=mikan_project
ENV BGMI_ADMIN_TOKEN=password

ADD ./ /home/bgmi-docker

RUN { \
	apk add --update linux-headers gcc python3-dev libffi-dev openssl-dev cargo libxslt-dev zlib-dev libxml2-dev musl-dev nginx bash supervisor transmission-daemon python3 cargo curl tzdata wget zip shadow; \
	curl https://bootstrap.pypa.io/get-pip.py | python3; \
	pip install cryptography; \
	pip install 'transmissionrpc'; \
}

RUN \
    ## 创建用户
    addgroup -S abc && \
    adduser -S abc -G abc -h /home/abc && \
    usermod -s /bin/bash abc && \
    ## Bgmi程序主体下载安装
    mkdir -p /home/bgmi-docker && \
    cd /home/bgmi-docker && \
    wget https://github.com/BGmi/BGmi/archive/refs/heads/master.zip && \
    unzip /home/bgmi-docker/master.zip && \
    mv /home/bgmi-docker/BGmi-master /home/bgmi-docker/BGmi && \
    mv /home/bgmi-docker/utils/crontab.sh /home/bgmi-docker/BGmi/bgmi/others/crontab.sh && \
    pip install /home/bgmi-docker/BGmi && \
    ## transmission-web-control安装
    mkdir -p /home/bgmi-docker/transmission-web-control && \
    cd /home/bgmi-docker/transmission-web-control && \
    wget https://github.com/ronggang/transmission-web-control/raw/master/release/install-tr-control-cn.sh --no-check-certificate && \
    echo 1 | bash install-tr-control-cn.sh && \
    ## 给予启动脚本权限
    chmod 755 /home/bgmi-docker/entrypoint.sh && \
    ## 清理
    rm -rf /home/bgmi-docker/master.zip && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    rm -rf /tmp/*

VOLUME ["/bgmi"]
VOLUME [ "/media" ]

EXPOSE 80 9091 51413/tcp 51413/udp

ENTRYPOINT ["/home/bgmi-docker/entrypoint.sh"]