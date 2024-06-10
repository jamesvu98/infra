resource "hcloud_server" "this" {
  name        = var.server_name
  image       = "ubuntu-24.04"
  server_type = "cax11"
  location    = "nbg1"
  ssh_keys    = [hcloud_ssh_key.this.name]

  user_data = <<-EOT
  #cloud-config
  runcmd:
    - |
      # Install Docker
      apt upgrade
      apt-get update
      apt-get install -y ca-certificates curl
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
      chmod a+r /etc/apt/keyrings/docker.asc
      echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      # Caddy
      cd /root
      cat > Caddyfile <<EOF
      :80 {
        respond "Hello, world!"
      }
      EOF
      cat > compose.yaml <<EOF
      name: caddy
      services:
        caddy:
          image: caddy
          restart: unless-stopped
          ports: 
            - "80:80"
            - "443:443"
            - "443:443/udp"
          volumes:
            - ./Caddyfile:/etc/caddy/Caddyfile
            - ./sites:/srv
            - caddy_data:/data
            - caddy_config:/config
      volumes:
        caddy_data:
        caddy_config:
      EOF
      docker compose up -d
  EOT
}

resource "hcloud_ssh_key" "this" {
  name       = var.ssh_key_name
  public_key = var.ssh_public_key
}

output "ipv4_address" {
  value = hcloud_server.this.ipv4_address
}