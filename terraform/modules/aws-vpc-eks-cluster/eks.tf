module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.17"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    default = {
      desired_capacity = var.k8s_desired_capacity
      min_capacity     = var.k8s_min_capacity
      max_capacity     = var.k8s_max_capacity

      instance_type = var.k8s_instance_type
    }
  }

  write_kubeconfig   = true
  config_output_path = "./"
  wait_for_cluster_interpreter = ["C:/Program Files/Git/bin/sh.exe", "-c"] //required to run on windows
  manage_aws_auth = false
  cluster_security_group_id = aws_security_group.eks_cluster_security_group.id

  depends_on = [aws_security_group.eks_cluster_security_group]
}

resource "aws_security_group" "eks_cluster_security_group"{
  name = "eks-cluster-sg-${var.env}"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

