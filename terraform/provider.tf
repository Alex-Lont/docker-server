terraform {
  required_providers {
    pihole = {
      source  = "ryanwholey/pihole"
      version = "0.2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "pihole" {
  url       = var.pihole_prim_url
  api_token = var.pihole_prim_token
}

provider "pihole" {
  alias = "sec"
  url       = var.pihole_sec_url
  api_token = var.pihole_sec_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}