variable "pihole_prim_url" {
  type = string
}

variable "pihole_prim_token" {
  type = string
  sensitive = true
}

variable "pihole_sec_url" {
  type = string
}

variable "pihole_sec_token" {
  type = string
  sensitive = true
}

variable "cloudflare_api_token" {
  type = string
  sensitive = true
}