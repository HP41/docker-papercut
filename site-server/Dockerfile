FROM ubuntu:xenial
LABEL maintainer="Hitesh Prabhakar <HP41@github>"
LABEL description="PaperCut MF Secondary Site Server"

ENV SERVERTYPE ––site-server
ENV PAPERCUT_MAJOR_VER 17.x
ENV PAPERCUT_VER 17.2.3
ENV PAPERCUT_DOWNLOAD_URL https://cdn.papercut.com/files/mf/${PAPERCUT_MAJOR_VER}/pcmf-setup-${PAPERCUT_VER}-linux-x64.sh

COPY entrypoint.sh /

RUN useradd -mUd /papercut -s /bin/bash papercut && \
    mkdir -p /papercut/server/data && \
    chown -R papercut:papercut /papercut && \
    chmod +x /entrypoint.sh && \
    apt-get update && \
    apt-get install -y \
                    curl \
                    cpio && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -L "https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb" -o /dumb-init.deb && \
    dpkg -i dumb-init.deb && \
    rm -rf dumb-init.deb && \
    curl -L "${PAPERCUT_DOWNLOAD_URL}" -o /pcmf-setup.sh && \
    chmod a+rx /pcmf-setup.sh && \
    runuser -l papercut -c "/pcmf-setup.sh --non-interactive $SERVERTYPE" && \
    rm -f /pcmf-setup.sh && \
    /papercut/MUST-RUN-AS-ROOT && \
    /etc/init.d/papercut stop && \
    /etc/init.d/papercut-web-print stop

VOLUME /papercut
EXPOSE 9191 9192 9193

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint.sh"]