# hp41/papercut-cups - CUPS Print Provider for Papercut

## [Papercut MF](https://www.papercut.com/products/mf/)
**[PLEASE AGREE TO PAPERCUT'S TOS BEFORE CONTINUING](https://www.papercut.com/products/ng/manual/common/topics/license.html)**

-------

## Docker Image features
- Has CUPS installed.
- `papercut` account setup. Home dir=`/papercut`.
- A CUPS admin account is setup (in entrypoint) - Default=`cups_admin`.
- Papercut CUPS print provider setup under `/papercut`.
- `/etc/init.d/cups` is started in the background.
- `/papercut/providers/print/linux-x64/pc-event-monitor` started in console therefore it outputs to stdout.

---------

## Folders/files inside the container that can be of interest
- [/papercut/providers/print/linux-x64/print-provider.conf](https://www.papercut.com/products/ng/manual/common/topics/secondary-linux.html)
- [/etc/cups/](https://www.cups.org/documentation.html)
    - cupsd.conf
    - cups-browsed.conf
    - cups-files.conf
    - printers.conf
    - snmp.conf
    - cups-pdf.conf
- [/opt/share/ppd](https://www.cups.org/doc/man-cupsd-helper.html) - Custom PPDs can be placed here.

---------

```bash
# docker run example
docker run -d \
    -p 631:631 \
    -e "CUPS_ADMIN_PWD=test12345" \
    -v /path/on/host/to/print-provider.conf:/papercut/providers/print/linux-x64/print-provider.conf \
    -v /path/on/host/to/cupsd.conf:/etc/cups/cupsd.conf \ 
    hp41/papercut-cups-provider
```