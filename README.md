# aria2-ui

This is container with Aria2 and 3 different WebUIs. Based on https://gist.github.com/GAS85/79849bfd09613067a2ac0c1a711120a6

## Usage

Container based on [alpine](https://registry.hub.docker.com/_/alpine) image with only needed packages. Per default will start `aria2c` with RPC on port `6800`, web UI on port `8080`. Optionally you can open port TCP and UDP `6801` for torrents.

### Use different web UIs

There are 3 web UIs that you can use, update variable `ARIA_WEB_UI` to needed value. Supported are:

- `ARIA_WEB_UI=`[`webui`](https://github.com/ziahamza/webui-aria2)
- `ARIA_WEB_UI=`[`ariang`](https://github.com/mayswind/AriaNg) (defalut)
- `ARIA_WEB_UI=`[`ariaNgDark`](https://github.com/rickylawson/AriaNgDark/)

### Mount Folders

There are 2 folders that you may mount to your system:

- `/configuration` - this folder will have configuration that you could edit, DHT and log files.
- `/data` - this folder contains your downloaded files.

### Docker CLI

Minimum command to run is:

```shell
docker run -d --name aria2-ui -p 6800:6800 -p 8080:8080 -v $PWD/aria2-downloads:/data gas85onlyone/aria2-ui:latest
```

Add open torrent ports, set own `RPC_SECRET`, set configuration path, etc.:

```shell
docker run -d \
    --name aria2-ui \
    --restart unless-stopped \
    -e RPC_SECRET=<TOKEN> \
    -e PUID=$UID \
    -e PGID=$GID \
    -p 6800:6800 \
    -p 8080:8080 \
    -p 6801:6801 \
    -p 6801:6801/udp \
    -v $PWD/aria2:/configuration \
    -v $PWD/aria2-downloads:/data \
    gas85onlyone/aria2-ui:latest 
```

### Docker Compose

```yaml
version: "3.6"
services:
  aria2-ui:
    container_name: aria2-ui
    image: gas85onlyone/aria2-ui:latest 
    environment:
      - RPC_SECRET=YOUR_SECRET
      - TZ=Europ/Berlin
      - PUID=5000
      - PGID=5000
    volumes:
      - ${PWD}/aria2-conf:/configuration
      - ${PWD}/aria2-downloads:/data
    network_mode: bridge
    ports:
      # RPC
      - 6800:6800
      # Web UI
      - 8080:8080
      # Torrents
      - 6801:6801
      - 6801:6801/udp
    restart: unless-stopped
    logging:
      driver: json-file
      options:
        max-size: 10m
```

### Variables

| Variable | Function |
|----------|----------|
| `ARIA_WEB_UI` | You can choice between different UIs, supported are `ariang`, `webui`. Default `ariang` |
| `RPC_SECRET` | You can set RPC Secret. It is kindly recommended set it. |
| `RPC_USER` | As alternative to RPC Sercret you can set user. |
| `RPC_PASSWORD` | As alternative to RPC Sercret you can set password. |
| `TZ` | Set timezone |
| `PUID` | Set user ID to avoiod permissions issue |
| `PGID` | Set group ID to avoiod permissions issue |

### License

[GPL v3](https://github.com/GAS85/aria2-ui/blob/main/LICENSE)
