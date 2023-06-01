variable "region" {
  type        = string
  default = "us-central1"
}

variable "project" {
  type        = string
  default = "prod"
}

variable "vpc-name" {
  type        = string
  default = "prod"
}

variable "public-subnet" {
  type        = string
  default = "public-subnet"
}

variable "public-ip-cidr-range" {
  type        = string
  default = "10.0.0.0/28"
}

variable "private-subnet" {
  type        = string
  default = "private-subnet"
}

variable "private-ip-cidr-range" {
  type        = string
  default = "10.0.1.0/28"
}

variable "firewall-name" {
  type        = string
  default = "firewall-prod"
}

variable "router-name" {
  type        = string
  default = "router-prod"
}

variable "nat-name" {
  type        = string
  default = "nat-prod"
}

variable "k8s-cluster-name" {
  type        = string
  default = "gke-prod"
}
