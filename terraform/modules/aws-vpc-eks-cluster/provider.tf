provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "my-context"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}