data "template_file" "node_drainer_configmap" {
  template = "${file("${path.module}/templates/node-drainer-configmap.yaml")}"

  vars = {
    region               = "${var.region}"
    lifecycled_sns_topic = "${module.lifecycle.sns_topic_arn}"
    lifecycled_log_group = "${var.lifecycled_log_group}-${var.cluster_name}"
  }
}

resource "null_resource" "node_drainer" {
  depends_on = ["module.lifecycle"]

  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOF
for i in `seq 1 10`; do \
echo "${null_resource.node_drainer.triggers.node_drainer_configmap_rendered}" > node_drainer_configmap.yaml & \
echo "${null_resource.node_drainer.triggers.kube_config_map_rendered}" > kube_config.yaml & \
kubectl apply -f node_drainer_configmap.yaml --kubeconfig kube_config.yaml & \
kubectl apply -f ./files/node-drainer-daemonset.yaml --kubeconfig kube_config.yaml && break ||
sleep 10; \
done; \
rm node_drainer_configmap.yaml kube_config.yaml;
EOF

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered        = "${module.eks.kubeconfig}"
    node_drainer_configmap_rendered = "${data.template_file.node_drainer_configmap.rendered}"
    endpoint                        = "${module.eks.cluster_endpoint}"
  }
}

resource "null_resource" "kube2iam" {
  provisioner "local-exec" {
    working_dir = "${path.module}"

    command = <<EOF
for i in `seq 1 10`; do \
echo "${null_resource.kube2iam.triggers.kube_config_map_rendered}" > kube_config.yaml & \
kubectl apply -f ./files/kube2iam.yml --kubeconfig kube_config.yaml && break ||
sleep 10; \
done; \
rm kube_config.yaml;
EOF

    interpreter = ["/bin/sh", "-c"]
  }

  triggers {
    kube_config_map_rendered = "${module.eks.kubeconfig}"
    endpoint                 = "${module.eks.cluster_endpoint}"
  }
}
