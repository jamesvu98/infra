data "cloudflare_zones" "my-zone" {
  filter {
    name = var.cloudflare_zone_name
  }
}

resource "cloudflare_record" "vps_record_ipv4" {
  zone_id = one(data.cloudflare_zones.my-zone.zones).id
  name    = "@"
  value   = hcloud_server.this.ipv4_address
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "vps_record_ipv6" {
  zone_id = one(data.cloudflare_zones.my-zone.zones).id
  name    = "@"
  value   = hcloud_server.this.ipv6_address
  type    = "AAAA"
  proxied = true
}