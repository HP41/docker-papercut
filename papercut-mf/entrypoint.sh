#!/bin/bash

# Fixing permissions after any volume mounts.
chown -R papercut:papercut /papercut
chmod +x /papercut/server/bin/linux-x64/setperms
/papercut/server/bin/linux-x64/setperms

if [[ -x /etc/init.d/papercut ]]; then
    if [[ -f /papercut/import.zip ]] && ! [[ -f /papercut/import.log ]]; then
        runuser -l papercut -c "yes | /papercut/server/bin/linux-x64/db-tools import-db -f /papercut/import.zip"
    fi

    echo "Starting Papercut service in console"
    exec /etc/init.d/papercut console
else
    echo "Papercut service not found/executable, maybe the docker image/build got corrupted? Exiting..."
fi