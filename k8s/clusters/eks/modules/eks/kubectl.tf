# TODO: Convert all of this into helm charts we can use
# after that start using the helm provider in terraform

data "template_file" "papertrail" {
  template = file("${path.module}/templates/fluentd-daemonset-papertrail.yaml")

  vars = {
    papertrail_hostname = var.cluster_name
  }
}

resource "null_resource" "papertrail" {
  provisioner "local-exec" {
    working_dir = path.module

    command = <<EOF
for i in `seq 1 10`; do \
echo "${null_resource.papertrail.triggers.papertrail_rendered}" > papertrail.yaml & \
echo "${null_resource.papertrail.triggers.kube_config_map_rendered}" > kube_config.yaml & \
kubectl apply -f papertrail.yaml --kubeconfig kube_config.yaml && break ||
sleep 10; \
done; \
rm papertrail.yaml kube_config.yaml;
EOF


    interpreter = ["/bin/sh", "-c"]
  }

  triggers = {
    kube_config_map_rendered = module.eks.kubeconfig
    papertrail_rendered      = data.template_file.papertrail.rendered
  }
}
