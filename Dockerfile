FROM codysk/bgmi-all-in-one:1.2.5

ENV PUID=1000
ENV PGID=1000

COPY ./bgmi_hardlink_helper /home/bgmi-docker/bgmi_hardlink_helper
ADD entrypoint.sh /home/bgmi-docker/entrypoint.sh
ADD ./conf/bgmi_nginx.conf /home/bgmi-docker/config/bgmi_nginx.conf

RUN mkdir -p /media && \
    chmod 755 /home/bgmi-docker/entrypoint.sh

VOLUME [ "/media" ]
