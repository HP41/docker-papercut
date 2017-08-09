FROM ubuntu:xenial
LABEL maintainer="Hitesh Prabhakar <HP41@github>"
LABEL description="CUPS IPP Print Provider for Papercut MF"

ENV PAPERCUT_MAJOR_VER 17.x
ENV PAPERCUT_VER 17.2.3
ENV PAPERCUT_DOWNLOAD_URL https://cdn.papercut.com/files/mf/${PAPERCUT_MAJOR_VER}/pcmf-setup-${PAPERCUT_VER}-linux-x64.sh

COPY entrypoint.sh /

RUN \
# Creating the necessary 'papercut' user
    useradd -mU -d /papercut -s /bin/bash papercut && \
    chmod +x /entrypoint.sh && \

# Installing necessary packages and cleaning up
    apt-get update && \
    apt-get install -y \
                    curl \
                    makepasswd \
                    cpio \
                    cups \
                    cups-pdf \
                    hplip \
                    openprinting-ppds && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \

# Disable some cups backend that are unusable within a container
    mv /usr/lib/cups/backend/parallel /usr/lib/cups/backend-available/ && \
    mv /usr/lib/cups/backend/serial /usr/lib/cups/backend-available/ && \

# Creating printers.conf otherwise papercut-event-monitor will fail.
    touch /etc/cups/printers.conf && \
    chown -R root:lp /etc/cups && \

# Grabbing dumb-init for a simple init system in container so it doesn't
# run as PID 1
    curl -L "https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb" -o /dumb-init.deb && \
    dpkg -i dumb-init.deb && \
    rm -rf dumb-init.deb && \

# Creating necessary dirs
    mkdir -p \
            /pc-installer \
            /papercut/providers/print/linux-x64 && \

# Downloading Papercut MF and extracting it
    cd /pc-installer && \
    curl -L "${PAPERCUT_DOWNLOAD_URL}" -o ./pcmf-setup.sh && \
    chmod a+rx ./pcmf-setup.sh && \
    ./pcmf-setup.sh -e && \
    cd / && \

# Copying the print-provider to the proper location and deleting the installer files
    cp -r /pc-installer/papercut/providers/print/linux-x64/. /papercut/providers/print/linux-x64/ && \
    rm -rf /pc-installer && \

# Ensuring permissions are set correctly
    chown -R papercut:papercut /papercut && \
    chmod +x /papercut/providers/print/linux-x64/setperms && \

# Running the print-provider tasks and stopping the services thereafter
    /papercut/providers/print/linux-x64/setperms && \
    /papercut/providers/print/linux-x64/roottasks && \
    /etc/init.d/papercut-event-monitor stop && \
    /etc/init.d/cups stop

VOLUME /papercut /etc/cups /var/log/cups /var/spool/cups
EXPOSE 631

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/entrypoint.sh"]