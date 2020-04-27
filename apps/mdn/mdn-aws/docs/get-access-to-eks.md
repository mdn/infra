# Getting access to the MDN EKS Cluster

MDN will be moving to a managed kubernetes service offered by AWS [(EKS)][eks], and you need to make
sure there is a mapping of IAM Roles in the kubernetes cluster to ensure that EKS knows how to authorize you
into the cluster. You can view an example on how we map an IAM role to a cluster [here](https://github.com/mdn/infra/blob/master/k8s/clusters/eks/us-west-2/main.tf#L54)

## Getting EKS credentials
Once there is a mapping you can request for a kubeconfig using the AWS CLI. Read [getting access to AWS Console](get-access-to-eks.md) about how 
to get AWS CLI access using `maws`.

You can then list the clusters you have on that particular AWS account by running the following command

```bash
$ aws eks list-clusters --region us-west-2
{
    "clusters": [
        "mdn-apps-a",
        "mdn"
    ]
}
```

Once you know which EKS cluster you need to get its config for, you can run the following command  to get the config

```bash
$ aws eks update-kubeconfig --region us-west-2 --name mdn --alias mdn --kubeconfig ~/.kube/mdn-apps-a.config
```

After that you can export `KUBECONFIG` and run your `kubectl` commands

```bash
$ export KUBECONFIG=~/.kube/mdn-apps-a.config
$ kubectl cluster-info
```

## Notes
You will need AWS CLI to be version `1.18.17` or greater for this to work so make sure you update `awscli` on your system


[eks]: https://aws.amazon.com/eks/
