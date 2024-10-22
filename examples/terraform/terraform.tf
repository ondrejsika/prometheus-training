variable "digitalocean_token" {}
provider "digitalocean" {
  token = var.digitalocean_token
}

variable "cloudflare_api_token" {}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

locals {
  vm_count             = 1
  example_vm_count     = 3
  sikadev_com_zone_id  = "b43309a2d6aa933138a03dffc8f341f3"
  sikademo_com_zone_id = "f2c00168a7ecd694bb1ba017b332c019"
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

resource "digitalocean_droplet" "droplet" {
  count = local.vm_count

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
    - slu install-bin training-cli -v v0.5.0-dev-6
    - HOME=/root training-cli prometheus vm-setup
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
  EOF
}

resource "cloudflare_record" "droplet" {
  count = local.vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom${count.index}"
  value   = digitalocean_droplet.droplet[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "droplet_all" {
  count = local.vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "prom-all"
  value   = digitalocean_droplet.droplet[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "droplet_wildcard" {
  count = local.vm_count

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
    - slu install-bin training-cli -v v0.5.0-dev-6
    - HOME=/root training-cli prometheus vm-setup
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
    - docker run --rm -d -p 9115:9115 --name blackbox_exporter prom/blackbox-exporter:master
    - docker run --name push-gateway -d -p 9091:9091 prom/pushgateway
    - git clone https://github.com/ondrejsika/prometheus-training
    - cd prometheus-training/docker/prom.sikademo.com && docker-compose up -d
  EOF
}

resource "cloudflare_record" "prom" {
  zone_id = local.sikademo_com_zone_id
  name    = "prom"
  value   = digitalocean_droplet.prom.ipv4_address
  type    = "A"
  proxied = false
}

# Example VMs with Demo Data

resource "digitalocean_droplet" "example" {
  count = local.example_vm_count

  image  = "docker-18-04"
  name   = "example${count.index}"
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
    - ufw disable
    - docker run -d --net="host" --pid="host" -v "/:/host:ro,rslave" quay.io/prometheus/node-exporter:latest --path.rootfs=/host
    - docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=9338:9338 --detach=true --name=cadvisor gcr.io/cadvisor/cadvisor --port=9338
    - docker run --name random1 -d -p 9001:80 ondrejsika/random-metrics
    - docker run --name random2 -d -p 9002:80 ondrejsika/random-metrics
    - docker run --name random3 -d -p 9003:80 ondrejsika/random-metrics
    - docker run --name metgen1 -d -p 9011:8000 sikalabs/slu:v0.56.0-dev-1 slu metrics-generator server
    - docker run --name metgen2 -d -p 9012:8000 sikalabs/slu:v0.56.0-dev-1 slu metrics-generator server
    - docker run --name metgen3 -d -p 9013:8000 sikalabs/slu:v0.56.0-dev-1 slu metrics-generator server
  EOF
}

resource "cloudflare_record" "example" {
  count = local.example_vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "example${count.index}"
  value   = digitalocean_droplet.example[count.index].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "example_all" {
  count = local.example_vm_count

  zone_id = local.sikademo_com_zone_id
  name    = "example-all"
  value   = digitalocean_droplet.example[count.index].ipv4_address
  type    = "A"
  proxied = false
}
