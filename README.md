# rtorrent-docker

This image is heavily based off of [romancin](https://github.com/romancin/rutorrent-flood-docker)'s original work.
Thanks for that!

Every other service but rTorrent has been stripped, and configurations have been optimized for their usage.

Instructions: 
- Map any local port to 51415 for rtorrent 
- Map any local port to 3000 for SSL flood access
- Map a local volume to /config (Stores configuration data, including rtorrent session directory. Consider this on SSD Disk) 
- Map a local volume to /downloads (Stores downloaded torrents)

Sample run command:

For rtorrent 0.9.6 version:

```bash
docker run -d --name=rutorrent-flood \
-v /share/Container/rutorrent-flood/config:/config \
-v /share/Container/rutorrent-flood/downloads:/downloads \
-e PGID=0 -e PUID=0 -e TZ=Europe/Madrid \
-p 9443:443 \
-p 3000:3000 \
-p 51415-51415:51415-51415 \
romancin/rutorrent-flood:latest
```

Remember to edit `/config/rtorrent/rtorrent.rc` with your own settings, especially your watch subfolder configuration.
