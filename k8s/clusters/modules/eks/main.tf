provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1"
}

provider "helm" {
  version = "~> 1"

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 11"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = var.eks_subnets

  worker_groups = var.worker_groups
  node_groups   = var.node_groups

  map_roles        = var.map_roles
  map_users        = var.map_users
  kubeconfig_name  = var.cluster_name
  write_kubeconfig = "false"
  manage_aws_auth  = "true"
  enable_irsa      = true

  tags = var.tags
}

