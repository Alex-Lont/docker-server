data "cloudflare_zone" "URL" {
  name = local.base_url
}

data "http" "myip" {
  url = "https://ifconfig.me"
}

output "Public_IP" {
  value = data.http.myip.response_body
}

resource "cloudflare_record" "A_Record" {
  name    = local.base_url
  type    = "A"
  content   = data.http.myip.response_body
  proxied = true
  allow_overwrite = true
  zone_id = data.cloudflare_zone.URL.id
}

resource "cloudflare_record" "public" {
  for_each = local.public_url
  name    = each.key
  type    = "CNAME"
  content = local.base_url
  proxied = true
  allow_overwrite = true
  zone_id = data.cloudflare_zone.URL.id
}

module "record" {
  source = "./modules/pihole-dns"
  url = local.urls
  providers = {
    pihole.one = pihole
    pihole.two = pihole.sec
  }
}

module "home_cname" {
  source = "./modules/pihole-cname"
  domain = local.home_cname
  target = local.home_url
  providers = {
    pihole.one = pihole
    pihole.two = pihole.sec
  }
}

module "iot_cname" {
  source = "./modules/pihole-cname"
  domain = local.iot_cname
  target = local.iot_url
  providers = {
    pihole.one = pihole
    pihole.two = pihole.sec
  }
}

module "docker_cname" {
  source = "./modules/pihole-cname"
  domain = local.docker_cname
  target = local.docker_url
  providers = {
    pihole.one = pihole
    pihole.two = pihole.sec
  }
}

module "base_cname" {
  source = "./modules/pihole-cname"
  domain = local.base_cname
  target = local.base_url
  providers = {
    pihole.one = pihole
    pihole.two = pihole.sec
  }
}