# SRE Info

## Infra Access
To access Kubernetes Masters, you will need your IP to be added to a whitelist in the secrets repo (see secrets below). After that you can request the kubeconfig file through kops:

```bash
# instructions for aws-vault is below
$ aws-vault exec mozilla-mdn-admin
$ git clone https://github.com/mdn/infra.git
$ cd infra/k8s/clusters/us-west-2a
$ source config.sh
$ kops export kubecfg --kubeconfig ~/.kube/mdn-us-west-2.config
```

[SRE aws-vault setup](https://mana.mozilla.org/wiki/display/SRE/aws-vault)

[SRE account guide](https://mana.mozilla.org/wiki/display/SRE/AWS+Account+access+guide)

[SRE AWS accounts](https://github.com/mozilla-it/itsre-accounts/blob/master/accounts/mozilla-itsre/terraform.tfvars#L5)

## Secrets
Secrets are stored in [mdn-k8s-private](https://github.com/mozilla/mdn-k8s-private), a private repo using git-crypt

[Private repo with git-crypt guide](https://mana.mozilla.org/wiki/display/SRE/Private+repos+with+git-crypt)

## Source Repos
Application repo [kuma](https://github.com/mozilla/kuma) and [kumascript](https://github.com/mdn/kumascript)

Infrastructure repo [mdn-infra](https://github.com/mdn/infra)

## Monitoring
[New Relic APM](https://rpm.newrelic.com/accounts/1807330/applications)

[New Relic Synthetics](https://synthetics.newrelic.com/accounts/1807330/synthetics)

## SSL Certificates
MDN uses certs from AWS ACM

[SSL Cert Monitoring](https://synthetics.newrelic.com/accounts/1807330/monitors/14756065-2a27-424a-8aa5-4d78d3647e84)

## Cloud Account
AWS account mozilla-mdn 178589013767

