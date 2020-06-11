
locals {

  mozit_charts_repo    = "https://mozilla-it.github.io/helm-charts"
  eks_charts_repo      = "https://aws.github.io/eks-charts"
  stable_charts_repo   = "https://kubernetes-charts.storage.googleapis.com"
  incubator_repository = "http://storage.googleapis.com/kubernetes-charts-incubator"

  cluster_autoscaler_name_prefix = "${module.eks.cluster_id}-cluster-autoscaler-${var.region}"

  cluster_autoscaler_versions = {
    "1.14" = "v1.14.8"
    "1.15" = "v1.15.6"
    "1.16" = "v1.16.5"
    "1.17" = "v1.17.2"
    "1.18" = "v1.18.1"
  }
  cluster_autoscaler_defaults = {
    "awsRegion"                                                     = var.region
    "image.repository"                                              = "us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler"
    "image.tag"                                                     = lookup(local.cluster_autoscaler_versions, var.cluster_version)
    "autoDiscovery.clusterName"                                     = module.eks.cluster_id
    "autoDiscovery.enabled"                                         = "true"
    "rbac.create"                                                   = "true"
    "rbac.serviceAccount.name"                                      = "cluster-autoscaler"
    "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn" = module.cluster_autoscaler_role.this_iam_role_arn
    "extraArgs.skip-nodes-with-system-pods"                         = "false"
    "extraArgs.balance-similar-node-groups"                         = "true"
  }
  cluster_autoscaler_settings = merge(local.cluster_autoscaler_defaults, var.cluster_autoscaler_settings)

  alb_ingress_namespace   = "kube-system"
  alb_ingress_name_prefix = "${module.eks.cluster_id}-alb-ingress-${var.region}"
  alb_ingress_defaults = {
    "clusterName"                                                    = var.cluster_name
    "autoDiscoverAwsRegion"                                          = "true"
    "awsVpcID"                                                       = var.vpc_id
    "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn" = module.alb_ingress_role.this_iam_role_arn
  }
  alb_ingress_settings = merge(local.alb_ingress_defaults, var.alb_ingress_settings)
}
