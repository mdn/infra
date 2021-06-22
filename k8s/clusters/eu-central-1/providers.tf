provider "aws" {
#  version = "~> 2"
  region  = var.region
}

provider "local" {
#  version = "~> 1.2"
}

provider "kubernetes" {
#  version                = "~> 1"
  alias                  = "mdn"
  host                   = data.aws_eks_cluster.mdn.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.mdn.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.mdn.token
#  load_config_file       = false
}

provider "helm" {
#  version = "~> 1"
  alias   = "mdn"

  kubernetes {
    host                   = data.aws_eks_cluster.mdn.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.mdn.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.mdn.token
#    load_config_file       = false
  }
}
