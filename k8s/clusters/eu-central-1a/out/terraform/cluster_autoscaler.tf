resource "aws_iam_policy" "nodes-k8s-eu-central-1a-mdn-mozit-cloud-autoscaler-policy" {
  name        = "nodes-k8s-eu-central-1a-mdn-mozit-cloud-autoscaler-policy"
  path        = "/"
  description = "Policy for K8s AWS autoscaler"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
								"autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "autoscaler-attach" {
  role       = "${aws_iam_role.nodes-k8s-eu-central-1a-mdn-mozit-cloud.name}"
  policy_arn = "${aws_iam_policy.nodes-k8s-eu-central-1a-mdn-mozit-cloud-autoscaler-policy.arn}"
}
