
resource "helm_release" "node_drain" {
  name       = "aws-node-termination-handler"
  repository = local.eks_charts_repo
  chart      = "aws-node-termination-handler"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = local.stable_charts_repo
  chart      = "cluster-autoscaler"
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
  chart      = "metrics-server"
  namespace  = "kube-system"

  depends_on = [module.eks]
}

resource "helm_release" "alb_ingress" {
  name       = "aws-alb-ingress-controller"
  repository = local.incubator_repository
  chart      = "aws-alb-ingress-controller"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.alb_ingress_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [module.eks]
}
