variable "digitalocean_token" {}
provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_api_token" {}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "vm_count" {
  default = 1
}
variable "demo_data_vm_count" {
  default = 3
}

locals {
  sikadev_com_zone_id  = "b43309a2d6aa933138a03dffc8f341f3"
  sikademo_com_zone_id = "f2c00168a7ecd694bb1ba017b332c019"
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

resource "digitalocean_droplet" "droplet" {
  count = var.vm_count

  image  = "docker-18-04"
  name   = "prom${count.index}"
  region = "fra1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: yes
  password: asdfasdf2021
  chpasswd:
    expire: false
  runcmd:
    - apt-get update
    - apt-get install -y curl sudo git vim htop
    - curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
    - install-slu install -v v0.54.0-dev-1
    - slu install-bin training-cli -v v0.5.0-dev-6
    - HOME=/root training-cli prometheus vm-setup
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
  EOF
}

resource "cloudflare_record" "droplet" {
  count = var.vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom${count.index}"
  value   = digitalocean_droplet.droplet[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "droplet_all" {
  count = var.vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom-all"
  value   = digitalocean_droplet.droplet[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "droplet_wildcard" {
  count = var.vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "*.prom${count.index}"
  value   = cloudflare_record.droplet[count.index].hostname
  type    = "CNAME"
  proxied = false
}

# Permanent Prometheus VM

resource "digitalocean_droplet" "prom" {
  image  = "docker-18-04"
  name   = "prom"
  region = "fra1"
  size   = "s-1vcpu-2gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: yes
  password: asdfasdf2021
  chpasswd:
    expire: false
  runcmd:
    - apt-get update
    - apt-get install -y curl sudo git vim htop
    - curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
    - install-slu install -v v0.54.0-dev-1
    - slu install-bin training-cli -v v0.5.0-dev-6
    - HOME=/root training-cli prometheus vm-setup
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
    - docker run --rm -d -p 9115:9115 --name blackbox_exporter prom/blackbox-exporter:master
  EOF
}

resource "cloudflare_record" "prom" {
  zone_id = local.sikademo_com_zone_id
  name    = "prom"
  value   = digitalocean_droplet.prom.ipv4_address
  type    = "A"
  proxied = false
}

# Demo Data

resource "digitalocean_droplet" "demo-data" {
  count = var.demo_data_vm_count

  image  = "docker-18-04"
  name   = "prom-demo-data${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<-EOF
  #cloud-config
  ssh_pwauth: yes
  password: asdfasdf2021
  chpasswd:
    expire: false
  runcmd:
    - apt-get update
    - apt-get install -y curl sudo git vim htop
    - curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
    - install-slu install -v v0.54.0-dev-1
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
    - docker run --name random -d -p 80:80 ondrejsika/random-metrics
  EOF
}

resource "cloudflare_record" "demo-data" {
  count = var.demo_data_vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom-demo-data${count.index}"
  value   = digitalocean_droplet.demo-data[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "demo-data_all" {
  count = var.demo_data_vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom-demo-data-all"
  value   = digitalocean_droplet.demo-data[count.index].ipv4_address
  type    = "A"
  proxied = false
}
