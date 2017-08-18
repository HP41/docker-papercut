# hp41/papercut-mf-site - Papercut-MF Site Server

## [Papercut MF](https://www.papercut.com/products/mf/)
**[PLEASE AGREE TO PAPERCUT'S TOS BEFORE CONTINUING](https://www.papercut.com/products/ng/manual/common/topics/license.html)**

-------

- Same as [papercut-mf](/papercut-mf) but Papercut is setup as a site server.
- On DockerHub - [hp41/papercut-mf](https://hub.docker.com/r/hp41/papercut-mf/)

-------

## docker run example
```bash
docker run -d \
    -p 9191:9191 \
    -p 9192:9193 \
    -p 9193:9193 \
    -v /path/on/host/to/server.properties:/papercut/server/server.properties \
    -v /path/on/host/to/database:/papercut/server/server/data/internal \
    -v /path/on/host/to/logs:/papercut/server/logs \
    -v /path/on/host/to/backups:/papercut/server/data/backups \
    hp41/papercut-mf-site
```