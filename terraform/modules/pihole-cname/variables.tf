variable "domain" {
    type = set(string)
    description = "Domain to create a CNAME record for"
}

variable "target" {
  type = string
  description = "Value of the CNAME record where traffic will be directed to from the configured domain value"
}