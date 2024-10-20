locals{
  private_dns = "192.168.7.11"
  public_dns = "192.168.7.10"
  base_url = "lontiotlabz.homes"  
  home_url = format("home.%s",local.base_url)
  iot_url = format("iot.%s",local.base_url)
  docker_url = format("docker.%s",local.base_url)
  urls = {
    (local.base_url) = (local.public_dns),
    (local.home_url) = (local.private_dns),
    (local.iot_url) = (local.private_dns),
    (local.docker_url) = (local.private_dns)
  }
  home_cname = [
    "proxmox",
    "traefik",
    "pihole",
    "pihole-backup",
    "omada",
    "truenas"
  ]
  iot_cname =[
    "rak",
    "archer",
    "nvr",
    "milesight",
    "tablet"
  ]
  docker_cname = [
    "home",
    "qbit",
    "sonarr",
    "radarr",
    "jackett",
    "bazarr",
    "organiser",
    "tdarr",
    "speed",
    "notes",
    "ansible",
    "books",
    "audiobook"
  ]
  base_cname = [
    "nextcloud",
    "nextcloudaio",
    "notify",
    "warden",
    "traefik",
    "plex",
    "homeassistant"
  ]
  public_url = toset([
    "www",
    "nextcloud",
    "warden",
    "plex",
    "homeassistant"
  ])
}
