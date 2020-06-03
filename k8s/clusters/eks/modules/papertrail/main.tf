locals {
  mozit_charts_repo = "https://mozilla-it.github.io/helm-charts"
  papertrail_defaults = {
    "clusterName"  = var.eks_cluster_id
    "secrets.name" = "papertrail"
  }
  papertrail_settings = merge(local.papertrail_defaults, var.papertrail_settings)
}

resource "helm_release" "fluentd-papertrail" {
  name       = "fluentd-papertrail"
  repository = local.mozit_charts_repo
  chart      = "fluentd-papertrail"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.papertrail_settings

    content {
      name  = item.key
      value = item.value
    }
  }
}
