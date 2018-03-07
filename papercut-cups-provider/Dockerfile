FROM ubuntu:xenial
LABEL maintainer="Hitesh Prabhakar <HP41@github>"
LABEL description="CUPS IPP Print Provider for Papercut MF"

ENV PAPERCUT_MAJOR_VER 18.x
ENV PAPERCUT_VER 18.0.4
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
                    openprinting-ppds \
                    python \
                    python-pip \
                    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install virtualenv && \

# Disable some cups backend that are unusable within a container
    mv /usr/lib/cups/backend/parallel /usr/lib/cups/backend-available/ && \
    mv /usr/lib/cups/backend/serial /usr/lib/cups/backend-available/ && \

# Creating printers.conf otherwise papercut-event-monitor will fail.
    touch /etc/cups/printers.conf && \
    chown -R root:lp /etc/cups && \

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
    /etc/init.d/cups stop && \

# Including the ansible role to install printers specified in a yml file.
    mkdir -p /install-printers && \
    git clone https://github.com/HP41/ansible-cups.git /install-printers && \
    virtualenv -p /usr/bin/python2.7 /install-printers

COPY install-printers/* /install-printers/

# Installing ansible under virtualenv and downloading playbook roles.
RUN . /install-printers/bin/activate && \
    pip install ansible && \
    mkdir -p /install-printers/roles && \
    ansible-galaxy install \
        --role-file=/install-printers/requirements.yml \
        --roles-path=/install-printers/roles/ \
        --force \
        --ignore-errors && \
    deactivate

VOLUME /papercut /opt/share/ppd /etc/cups /var/log/cups /var/spool/cups
EXPOSE 631

ENTRYPOINT ["/entrypoint.sh"]