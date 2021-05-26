variable "env" {
  description = "Name of the environment"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "cluster_name" {
  description = "Name of the EKS Cluster"
}

variable "k8s_desired_capacity" {
  description = "Desired number of nodes for the EKS Cluster"
}

variable "k8s_min_capacity" {
  description = "Minimum number of nodes for the EKS Cluster"
}

variable "k8s_max_capacity" {
  description = "Maximum number of nodes for the EKS Cluster"
}

variable "k8s_instance_type" {
  description = "Instance class of the EKS nodes"
}