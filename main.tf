provider "google" {
  project = "vegetable-couscous"
  region  = "europe-west4"
}

data "google_client_config" "this" {}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.3"

  project_id   = data.google_client_config.this.project
  network_name = "couscous-vpc"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "envoy-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = data.google_client_config.this.region
      purpose       = "REGIONAL_MANAGED_PROXY"
      role          = "ACTIVE"
      description   = "Contains the envoy-based load balancer."
    },
    {
      subnet_name           = "private-subnet"
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = data.google_client_config.this.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true" # would set this up in all production subnets
      description           = "Contains the bucket, message bus, and Cloud Run function."
      purpose               = "PRIVATE"
    }
  ]

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}