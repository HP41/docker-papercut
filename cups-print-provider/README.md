# hp41/papercut-cups - CUPS Print Provider for Papercut

- Has CUPS installed.
- `papercut` account setup. Home dir=`/papercut`.
- A CUPS admin account is setup (in entrypoint) - Default=`cups_admin`.
- Papercut CUPS print provider setup under `/papercut`.
- `/etc/init.d/cups` is started in the background.
- `/papercut/providers/print/linux-x64/pc-event-monitor` started in console therefore it outputs to stdout.

---------

- Folders/files inside the container that can be of interest
    - `/papercut/providers/print/linux-x64/print-provider.conf`
    - `/etc/cups/`
        - `cupsd.conf`
        - `cups-browsed.conf`
        - `cups-files.conf`
        - `printers.conf`
        - `snmp.conf`
        - `cups-pdf.conf`
    - `/opt/share/ppd` - Custom PPDs can be placed here.