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

# Allow SSM access
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = module.eks.worker_iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

module "lifecycle" {
  source = "github.com/mozilla-it/terraform-modules//aws/asg-lifecycle?ref=master"

  name                 = var.cluster_name
  worker_asg           = module.eks.workers_asg_names
  worker_asg_count     = "1"
  worker_iam_role      = module.eks.worker_iam_role_name
  lifecycled_log_group = "${var.lifecycled_log_group}-${var.cluster_name}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "10.0.0"

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

