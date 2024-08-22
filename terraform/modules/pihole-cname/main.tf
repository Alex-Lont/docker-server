terraform {
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.2.0"
      configuration_aliases = [ pihole.one, pihole.two ]
    }
  }
}

resource "pihole_cname_record" "cname_one" {
  for_each = var.domain
  domain = format("%s.%s", each.key, var.target)
  target = var.target
  provider = pihole.one
}

resource "pihole_cname_record" "cname_two" {
  for_each = var.domain
  domain = format("%s.%s", each.key, var.target)
  target = var.target
  provider = pihole.two
}
