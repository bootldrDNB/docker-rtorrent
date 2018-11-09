# docker-rtorrent

This repository is the result of many hours of research and banging my head against the wall trying to figure out this new technology.

Sources used:

  - [Wonderfall/docker-rtorrent-flood](https://github.com/Wonderfall/docker-rtorrent-flood)
  - [linuxserver/docker-rutorrent](https://github.com/linuxserver/docker-rutorrent)
  - [romancin/rutorrent-flood-docker](https://github.com/romancin/rutorrent-flood-docker)
  
  rTorrent is listening on port `51415`.
  Directories used are: `/downloads` for your downloaded files, and `/config` for your rTorrent configuration files and watch folders.
  Bind these folders in your respective configuration utilities.
  
  To use this image, use either `docker build` or `docker-compose`.
  A docker-compose file for this project can look something like this, tweak them to your needs!
  
```yaml
  version: "3"

services:
  rtorrent:
    build: .
    environment:
      - PUID=1000
      - PGID=1000
      - TZ="Europe/Amsterdam"
    container_name: rtorrent
    network_mode: host
    restart: always
    volumes:
      - "/storage/rtorrent/downloads/:/downloads"
      - "/storage/rtorrent/instance/:/config/rtorrent"
    ports:
      - "51415:51415"

```
