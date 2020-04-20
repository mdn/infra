
locals {

  cluster_autoscaler_versions = {
    "1.13" = "v1.13.9"
    "1.14" = "v1.14.7"
    # By default this should be 1.15.5 but
    # they have not released a version in the 1.15.x branch
    # to accept irsa yet (IAM Roles for Service accounts)
    # See: https://github.com/kubernetes/autoscaler/issues/2920
    "1.15" = "v1.14.7"
    "1.16" = "v1.16.4"
    "1.17" = "v1.17.1"
  }
  cluster_autoscaler_defaults = {
    "awsRegion"                                                     = var.region
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
}
