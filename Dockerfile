FROM alpine:3.16

LABEL origin.repository="https://github.com/GAS85/aria2-ui" \
      version=0.1.0

ENV ARIA_WEB_UI=ariang

# Install Aria2
RUN apk update && \
    apk add --no-cache --update \
    sed \
    aria2 \
    darkhttpd && \
    aria2c --version && \
    mkdir -p /configuration && \
    mkdir -p /start && \
    mkdir -p /data

# Insert Configuration and Starting script
COPY start.sh /start/start.sh
COPY aria2.conf /start/aria2.conf

#RUN chmod +x /start/start.sh

# Install Aria2 UIs
RUN apk add --no-cache --update \
    zip && \
    # Aria2 WebUI
    wget https://github.com/ziahamza/webui-aria2/archive/master.zip && \
    unzip master.zip && \
    mv webui-aria2-master/docs /webui && \
    rm -r webui-aria2-master && \
    # AriaNg
    mkdir /ariang && \
    wget https://github.com/mayswind/AriaNg/releases/download/1.2.4/AriaNg-1.2.4-AllInOne.zip && \
    unzip AriaNg-1.2.4-AllInOne.zip -d ariang && \
    # AriaNgDark
    mkdir /ariaNgDark && \
    wget https://raw.githubusercontent.com/rickylawson/AriaNgDark/main/index.html -O /ariaNgDark/index.html && \
    # Cleanup
    rm *.zip && \
    apk del \
    zip

WORKDIR /

VOLUME /data /configuration

# Aria2 RPC
EXPOSE 6800
# DHT and Torrents inbounds
EXPOSE 6801/tcp
EXPOSE 6801/udp
# Web UI
EXPOSE 8080

CMD ["/bin/sh", "-c", "/start/start.sh"]
