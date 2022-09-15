resource "kubernetes_namespace" "telegraf" {
  metadata {
    name = var.telegraf_namespace
  }
}

resource "helm_release" "telegraf" {
  name       = "telegraf"
  repository = "https://helm.influxdata.com/"
  chart      = "telegraf"
  version    = "1.8.20"

  namespace = var.telegraf_namespace

  values = [
    "${file("${path.module}/files/values.yaml")}"
  ]

  set {
    name  = "config.global_tags.cluster_name"
    value = var.cluster_name
  }

  set {
    name  = "config.global_tags.cluster_region"
    value = var.cluster_region
  }

  set {
    name  = "config.global_tags.service"
    value = var.service_name
  }

  set {
    name  = "envFromSecret"
    value = var.telegraf_config_secret_name
  }
}
