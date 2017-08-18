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
- Includes Ansible role [cups](https://github.com/HP41/ansible-cups). 

---------

## Ansible role [cups](https://github.com/HP41/ansible-cups) details 
- Just runs the remove/purge/install printers and classes tasks.
    - This is useful for managing printer(s).
    - This is setup in `/install-printers` directory within the container.
    - For the role to manage printers and classes, their definitions can be placed in these files:
        - Inside container: `/install-printers/group_vars/printer_list.yml`
            - **Ensure to place the list of printer definitions under the variable: `printer_list`**.
        - Inside container: `/install-printers/group_vars/class_list.yml`
            - **Ensure to place the list of printer definitions under the variable: `class_list`**.
    - Have look at how the printer and class definitions can be listed here:
        - [The `cups_lpadmin` module that does the heavy lifting](https://github.com/HP41/ansible-cups/blob/master/library/cups_lpadmin.py)
        - [Example printer_list.yml](../example/pc-cups/printer_list)
        - [Example class_list.yml](../example/pc-cups/class_list)

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
- [/install-printers/group_vars](#ansible-role-cups-details)
    - printer_list.yml
    - class_list.yml

---------

## docker run example
```bash
docker run -d \
    -p 631:631 \
    -e "CUPS_ADMIN_PWD=test12345" \
    -e "ANSIBLE_MANAGE_PRINTERS=true" \
    -v /path/on/host/to/print-provider.conf:/papercut/providers/print/linux-x64/print-provider.conf \
    -v /path/on/host/to/cupsd.conf:/etc/cups/cupsd.conf \
    -v /path/on/host/to/printer_list.yml:/install-printers/group_vars/printer_list.yml \
    -v /path/on/host/to/class_list.yml:/install-printers/group_vars/class_list.yml \
    hp41/papercut-cups-provider
```