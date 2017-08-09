#!/bin/bash

CUPS_ADMIN_USN=${CUPS_ADMIN_USN:-"cups_admin"}

id ${CUPS_ADMIN_USN}

if [[ $? == 1 ]]; then 
    echo "${CUPS_ADMIN_USN} isn't present, Creating ${CUPS_ADMIN_USN}..."

    if [[ -z "$CUPS_ADMIN_PWD" ]]; then
        CUPS_ADMIN_PWD=$(makepasswd)
        echo "CUPS_ADMIN_PWD not specified, therefore the following random password will be set for '${CUPS_ADMIN_USN}': ${CUPS_ADMIN_PWD}"
    fi

    useradd -U \
        -md /home/${CUPS_ADMIN_USN} \
        -p $(openssl passwd -1 ${CUPS_ADMIN_PWD}) \
        ${CUPS_ADMIN_USN}
fi

usermod -aG lpadmin ${CUPS_ADMIN_USN}

# Fixing permissions after any volume mounts.
chown -R papercut:papercut /papercut
chown -R root:lp /etc/cups

chmod +x /papercut/providers/print/linux-x64/setperms
/papercut/providers/print/linux-x64/setperms

if [[ -x /etc/init.d/papercut-event-monitor ]] && [[ -x /etc/init.d/cups ]]; then
    /etc/init.d/cups start
    echo "Sleeping for 30sec to wait for cups to start"
    sleep 30s
    echo "Starting Papercut Event Monitor"
    exec /papercut/providers/print/linux-x64/pc-event-monitor
else
    echo "Papercut Print Provider event monitor service and CUPS service not found/executable, maybe the docker image/build got corrupted? Exiting..."
fi