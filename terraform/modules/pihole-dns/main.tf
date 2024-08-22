terraform {
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.2.0"
      configuration_aliases = [ pihole.one, pihole.two ]
    }
  }
}

resource "pihole_dns_record" "record_one" {
  for_each = var.url
  domain = each.key
  ip     = each.value
  provider = pihole.one
}

resource "pihole_dns_record" "record_two" {
  for_each = var.url
  domain = each.key
  ip     = each.value
  provider = pihole.two
}