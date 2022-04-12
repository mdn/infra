# MDN AWS

- [Support documentation](https://github.com/mozmeao/infra/blob/master/apps/mdn/mdn-aws/docs/mdn-support.md)
- [Deployment documentation](https://github.com/mozmeao/infra/blob/master/apps/mdn/mdn-aws/k8s/README.md)

## MDN AWS provisioning

---
- ### NOTE  arm64/Apple Silicon users.

  As of writing (Terraform v1.1.8) you will need to do run the following before executing terraform commands

  -  ```export GODEBUG=asyncpreemptoff=1 ```

--- 
### Requirements:

- Terraform
- Access to the IAM role `admin` role via the AWS metadata API
- awscli

### Usage


#### shared resources (S3 buckets, etc):

```sh
cd ./infra/shared/
./provision.sh
```

#### Provisioning region-specific resources:

```sh
cd ./infra/multi_region/portland
./provision.sh
```
