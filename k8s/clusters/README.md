# EKS
This folder contains the terraform needed to stand up an EKS cluster in AWS. Each folder consists of EKS clusters hosted in separate regions

## Requirements
Here are the tools needed before you deploy an EKS cluster

* `kubectl` - Kubernetes client management tool
* `aws-iam-authenticator` - A tool to use AWS IAM credentials to authenticate to a Kubernetes cluster
* `awscli` - AWS CLI tool
* `mozilla-aws-cli-mozilla` - CLI tool to authenticate against mozilla sso

## Setting up credentials to EKS cluster

1. Get a list of clusters
```
$ aws eks list-clusters --region <Your region>
```
2. Identify your cluster and make note of the name of the cluster
3. Update kubeconfig to include new EKS cluster
```
$ aws eks update-kubeconfig --name <Name of your cluster> --region <Your region>
```


## Tips and tricks
The context name that you get from `aws eks update-kubeconfig` is just an ARN, and it might be helpful to just name to something more recognizable

You can rename your context using `kubectl`

1. Get the list of context you currently have and make note of the `cluster` and `authinfo`
```
$ kubectl config get-contexts
```
2. Rename your context
```
$ kubectl config set-context <New context name> --cluster <name of old context> --user <name of user from old context>
```
3. Delete old cluster context
```
kubectl config delete-context <Name of old cluster>
```
4. Start using new context
```
kubectl config set-context <Name of new cluster>
```
