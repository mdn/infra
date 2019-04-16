# VPC module
This creates the VPC for the MDN account

If you need to create a VPC for another region you will need to create a separate folder for the region, this allows us to have separate state files

## VPC
The current setup will create 3 private subnets and a NAT instance.

## Current status
Currently the module only the private subnets, the reason its only doing that is because the existing VPC was created using `kops`. There is an issue
to resolve this at some point. Going forward I hope to have the VPC create via Terraform.
