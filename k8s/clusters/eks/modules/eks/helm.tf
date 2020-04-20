
data "helm_repository" "eks" {
  name = "eks"
  url  = "https://aws.github.io/eks-charts"
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = data.helm_repository.eks.metadata.0.name
  chart      = "eks/aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/cluster-autoscaler"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.cluster_autoscaler_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = data.helm_repository.stable.metadata.0.name
  chart      = "stable/metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}
