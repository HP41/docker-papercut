# Example setup
- Please check [papercut-compose-example.yml](papercut-compose-example.yml)
- This assumes a reverse proxy setup that can handle the HTTPS and proper DNS names.

```bash
docker-compose \
    -f ./papercut-compose-example.yml \
    up -d
```