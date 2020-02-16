variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_token
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

data "cloudflare_zones" "demo" {
  filter {
    name = "sikademo.com"
  }
}

resource "digitalocean_droplet" "example" {
  # List DigitalOcean's public images: `doctl compute image list --public`
  image  = "docker-18-04"
  name = "example"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
}

resource "cloudflare_record" "example" {
  zone_id = lookup(data.cloudflare_zones.demo.zones[0], "id")
  name    = "example"
  value   = digitalocean_droplet.example.ipv4_address
  type    = "A"
  proxied = false
}
