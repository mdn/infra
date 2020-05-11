
resource "kubernetes_role" "this" {
  for_each = toset(var.namespace)

  metadata {
    name      = "${var.role_name}-access-${each.value}"
    namespace = each.value
    labels = {
      namespace = each.value
      app       = "${var.role_name}-rbac"
    }
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs = [
      "get",
      "list",
      "watch",
    ]
  }

  rule {
    api_groups = ["", "extensions", "apps", "autoscaling"]
    resources  = ["*"]
    verbs = [
      "get",
      "list",
      "watch",
      "create",
      "update",
      "patch",
      "delete"
    ]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs", "cronjobs"]
    verbs      = ["*"]
  }
}

resource "kubernetes_role_binding" "this" {
  for_each = toset(var.namespace)

  metadata {
    name      = "${var.role_name}-access-${each.value}"
    namespace = each.value

    labels {
      namespace = each.value
      app       = "${var.role_name}-rbac"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${var.role_name}-access-${each.value}"
  }

  subject {
    kind      = "Group"
    name      = "jenkins-access"
    namespace = each.value
  }
}
