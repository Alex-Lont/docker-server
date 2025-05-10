# Docker install of apps for media server

***Please note i am using x86 architecture. I have not tested this with arm***\
Docker compose configurations for media server with hardware transcode, download server, docker server & traefik internal and external.

## Containers

Run compose files with

```bash
docker compose -f compose.base.yaml pull

docker compose -f compose.downloads.yaml pull

docker compose -f compose.hardware.yaml pull

docker compose -f compose.nextcloud.yaml pull

docker compose -f compose.traefik-ext.yaml pull

docker compose -f compose.traefik-int.yaml pull
```

### Base

- [audiobookshelf](https://hub.docker.com/r/advplyr/audiobookshelf)
- [calibre](https://hub.docker.com/r/linuxserver/calibre)
- [SpeedTest](https://hub.docker.com/r/henrywhitaker3/speedtest-tracker)
- [Flatnotes](https://hub.docker.com/r/dullage/flatnotes)
- [Organizr](https://hub.docker.com/r/organizr/organizr)
- [mySQL](https://hub.docker.com/_/mysql)
- [Semaphore](https://hub.docker.com/r/semaphoreui/semaphore)

### Downloads

- [Qbittorrent with VPN](https://hub.docker.com/r/dyonr/qbittorrentvpn/)
- [Jacket with VPN](https://hub.docker.com/r/dyonr/jackettvpn)
- [Radarr](https://hub.docker.com/r/linuxserver/radarr)
- [Sonarr](https://hub.docker.com/r/linuxserver/sonarr)
- [Bazarr](https://hub.docker.com/r/linuxserver/bazarr)

### Hardware

***Using Intel HW***

- [Plex](https://hub.docker.com/r/linuxserver/plex)
- [Tdarr](https://hub.docker.com/r/haveagitgat/tdarr)

### Nextcloud

- [Nextcloud](nextcloud/all-in-one)

### Traefik-int

- [Traefik](https://hub.docker.com/_/traefik)
- [Homarr](https://github.com/ajnart/homarr)
- [Ntfy]{binwiederhier/ntfy}

### Traefik-ext

- [Traefik](https://hub.docker.com/_/traefik)

## Traefik

before using traefik make sure the acme.json file is created in the traefik folders

### Internal traefik

``` bash
touch traefik-int/acme.json

chmod 600 traefik-int/acme.json
```

### External traefik

``` bash
touch traefik-ext/acme.json

chmod 600 traefik-ext/acme.json
```

To enable external, A records need to be added to domain controller such as cloudflare.
Port forwarding for 443 to machine running this stack.

## Updating

### Update manually via watch tower

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once
```

## VPN Apps

**For vpn apps qbit and jacket**
copy vpn files into config

### Jackett

```bash
cp /PIAOpenvpn/ca.rsa.4096 ~/config/jackett/openvpn/ca.rsa.4096 

cp /PIAOpenvpn/ca.rsa.4096.pem ~/config/jackett/openvpn/ca.rsa.4096.pem

cp /PIAOpenvpn/Singapore.ovpn ~/config/jackett/openvpn/Singapore.ovpn

touch ~/config/jackett/openvpn/credentials/conf
```

add vpn username
add vpn password

### Qbit

```bash
cp /PIAOpenvpn/ca.rsa.4096 ~/config/qbittorent/openvpn/ca.rsa.4096

cp /PIAOpenvpn/ca.rsa.4096.pem ~/config/qbittorent/openvpn/ca.rsa.4096.pem 

cp /PIAOpenvpn/Singapore.ovpn ~/config/qbittorent/openvpn/Singapore.ovpn 

touch ~/config/jackett/openvpn/credentials/conf
```

add vpn username
add vpn password
