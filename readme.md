# Docker install of apps for media server

***Please note i am using x86 architecture. I have not tested this with arm***\
Docker compose configurations for media server with hardware transcode, download server, docker server, bitwarden & traefik internal and external.

Most docker compose files are using nfs volumes, this root folders must exist before docker can use them.

## Bash Script

***Designed for debian***\
Setup script to fetch .env variables from current system.
installs net-tools.
installs docker.
Optionally installs Hardware requirement fro docker passthough.

## Containers

### Base

- [SpeedTest](https://hub.docker.com/r/henrywhitaker3/speedtest-tracker)
- [Flatnotes](https://hub.docker.com/r/dullage/flatnotes)
- [Organizr](https://hub.docker.com/r/organizr/organizr)

### Downloads

- [Qbittorrent with VPN](https://hub.docker.com/r/dyonr/qbittorrentvpn/)
- [Jacket with VPN](https://hub.docker.com/r/dyonr/jackettvpn)
- [Radarr](https://hub.docker.com/r/linuxserver/radarr)
- [Sonarr](https://hub.docker.com/r/linuxserver/sonarr)
- [Bazarr](https://hub.docker.com/r/linuxserver/bazarr)

### Hardware

***Using Nvidia P400***

- [Plex](https://hub.docker.com/r/linuxserver/plex)
- [Tdarr](https://hub.docker.com/r/haveagitgat/tdarr)

### Nextcloud

- [Nextcloud](nextcloud/all-in-one)

### Traefik-int

- [Traefik](https://hub.docker.com/_/traefik)
- [Homarr](https://github.com/ajnart/homarr)

### Traefik-ext

- [Traefik](https://hub.docker.com/_/traefik)
- [Ntfy]{binwiederhier/ntfy}

### Warden

- [Bitwarden](https://bitwarden.com/help/install-and-deploy-unified-beta/)

## Docker Comands recreate

```bash
docker compose pull 

docker compose up -d

docker compose down

docker compose up -d --force-recreate

docker image prune -a 
```

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

### Update manually

```bash
docker compose pull

docker compose up -d 

docker image prune -f
```

## Pi Hole

### CNAME

```bash
code /etc/dnsmasq.d/05-pihole-custom-cname.conf  
```

### DNS

```bash
code /etc/pihole/custom.list
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

add vpn username\
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

## UFW

```bash
sudo ./ufw.sh
```

## Nvidia Docker

[Nvidia Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update

sudo apt install -y nvidia-docker2

sudo systemctl restart docker

docker run --rm --gpus all nvidia/cuda:12.1.1-devel-ubuntu22.04 nvidia-smi
```
