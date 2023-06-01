
provider "google" {
  // Refer to https://developers.google.com/workspace/guides/create-credentials  
  credentials = file("./credentials.json")
  project     = var.project
  region      = var.region
}

# Main VPC
resource "google_compute_network" "vpc" {
  name                    = var.vpc-name
  auto_create_subnetworks = false
}

# Public Subnet
resource "google_compute_subnetwork" "public-subnet" {
  name          = var.public-subnet
  ip_cidr_range = var.public-ip-cidr-range
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Private Subnet
resource "google_compute_subnetwork" "private-subnet" {
  name          = var.private-subnet
  ip_cidr_range = var.private-ip-cidr-range
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_firewall" "default" {
  name    = var.firewall-name
  network = google_compute_network.vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443" , "22"]
  }

  source_tags = ["web"]
}


# Cloud Router
resource "google_compute_router" "router" {
  name    = var.router-name
  network = google_compute_network.vpc.id
  bgp {
    asn            = 64514
    advertise_mode = "CUSTOM"
  }
}

# NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                               = var.nat-name
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = var.private-subnet
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
resource "google_container_cluster" "primary" {
  name     = var.k8s-cluster-name
  location = var.region
   private_cluster_config {

    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "192.0.1.0/28"

  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.private-subnet.name
 
# Enabling Autopilot for this cluster
  enable_autopilot = true
}
