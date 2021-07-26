# SRE Info

## Infra Access
Use the [`maws`](https://github.com/mozilla-iam/mozilla-aws-cli/) tool to get credentials to the mozilla-mdn account. Once you have access you can use the `aws eks` tooling to update your local `kubectl` config.

```bash
aws eks update-kubeconfig --alias mdn-us-west-2 --name mdn --region us-west-2
``` 

You can now interact with the cluster using the `kubectl` command.

[SRE account guide](https://mana.mozilla.org/wiki/display/SRE/AWS+Account+access+guide)

[SRE AWS accounts](https://github.com/mozilla-it/itsre-accounts/blob/master/accounts/mozilla-itsre/terraform.tfvars#L5)

## Secrets
Secrets are stored in [mdn-k8s-private](https://github.com/mozilla/mdn-k8s-private), a private repo using git-crypt

[Private repo with git-crypt guide](https://mana.mozilla.org/wiki/display/SRE/Private+repos+with+git-crypt)

## Source Repos
Application repos:
 * [kuma](https://github.com/mdn/kuma)
 * [yari](https://github.com/mdn/yari)

Infrastructure repo [mdn-infra](https://github.com/mdn/infra)

## Monitoring
[New Relic APM](https://rpm.newrelic.com/accounts/1807330/applications)

[New Relic Synthetics](https://synthetics.newrelic.com/accounts/1807330/synthetics)

## SSL Certificates
MDN uses certs from AWS ACM

[SSL Cert Monitoring](https://synthetics.newrelic.com/accounts/1807330/monitors/14756065-2a27-424a-8aa5-4d78d3647e84)

## Cloud Account
AWS account mozilla-mdn 178589013767
