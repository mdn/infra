data "aws_caller_identity" "current" {
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
  version = "5.1.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = var.eks_subnets

  worker_groups         = var.worker_groups
  tags                  = var.tags
  map_roles             = var.map_roles
  map_users             = var.map_users
  kubeconfig_name       = var.cluster_name
  write_kubeconfig      = "false"
  write_aws_auth_config = "false"
  manage_aws_auth       = "true"
}

