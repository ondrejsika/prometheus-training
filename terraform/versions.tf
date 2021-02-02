terraform {
  required_providers {
    cloudflare = {
      source = "terraform-providers/cloudflare"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
  required_version = ">= 0.13"
}
