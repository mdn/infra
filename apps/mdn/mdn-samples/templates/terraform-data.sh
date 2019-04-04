#!/bin/bash

# Get EIP id from userdata and dump it to the filesystem
echo "${eip_id}" > /etc/aws_eip_id
instance_id=$(/usr/bin/curl -fqs http://169.254.169.254/latest/meta-data/instance-id)

yum update
yum install -y -q git
yum install -y -q vim
yum install -y -q bind-utils
yum install -y -q make gcc cc gcc-c++
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
python /tmp/get-pip.py
pip install awscli

aws ec2 associate-address --instance-id "$${instance_id}" --allocation-id ${eip_id} --region ${region}

mkdir -p /opt/getssl/bin
curl --silent https://raw.githubusercontent.com/srvrco/getssl/master/getssl -o /opt/getssl/bin/getssl; chmod 700 /opt/getssl/bin/getssl
