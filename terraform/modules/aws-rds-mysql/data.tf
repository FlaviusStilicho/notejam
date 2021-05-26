data "aws_vpc" "selected" {
  tags = {
    Environment = var.env
  }
}

data "aws_security_group" "eks_cluster_security_group" {
  name = "eks-cluster-sg-${var.env}"
}
