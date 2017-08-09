# hp41/papercut-mf - Papercut-MF Standalone

- Standalone docker image with only Papercut installed, CUPS isn't installed.
- Necessary files/volumes can be mounted to ensure the right settings are used.
- PaperCut is already installed, therefore do not mount volumes over already existing files/folders that are crucial to the server operation unless you're overwriting config files.
- `papercut` account setup. Home dir=`/papercut`.
- Papercut installed to /papercut.
- `papercut` service is run as console therefore it ouputs to stdout.

-------

- Folders/files inside the container that can be of interest:
    - `/papercut/server/`
        - `server.properties`
        - `logs/`
        - `data/backups/`
        - `data/conf/`