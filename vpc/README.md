# VPC module
This creates the VPC for the MDN account.

If you need to create a VPC for another region you will need to create a separate folder for the region. This allows us to have separate state files

## VPC
The current setup will create 3 private subnets and a NAT instance.

## Current status
Currently the module only creates the private subnets. This is because the VPC was create using `kops`. This is an issue
to resolve, and going forward I hope to create the VPC using terraform
