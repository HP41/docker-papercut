#!/bin/bash

# Fixing permissions after any volume mounts.
chown -R papercut:papercut /papercut

if [[ -x /etc/init.d/papercut ]]; then
    if [[ -f /papercut/import.zip ]] && ! [[ -f /papercut/import.log ]]; then
        runuser -l papercut -c "yes | /papercut/server/bin/linux-x64/db-tools import-db -f /papercut/import.zip"
    fi

    exec /etc/init.d/papercut console
else
    echo "Papercut service not found/executable, maybe the docker image/build got corrupted? Exiting..."
fi