variable "hcloud_token" {
  type      = string
  sensitive = true
}

variable "server_name" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "cloudflare_zone_name" {
  type = string
}