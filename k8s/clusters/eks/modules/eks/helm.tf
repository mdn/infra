
resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = local.eks_charts_repo
  chart      = "eks/aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = local.stable_charts_repo
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
  repository = local.stable_charts_repo
  chart      = "stable/metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}
