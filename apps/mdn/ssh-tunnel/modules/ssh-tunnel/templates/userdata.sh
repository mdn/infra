#!/bin/bash

declare -A github_urls

# This  section is generated
%{ for users in github_users ~}
github_urls[${users}]="https://github.com/${users}.keys"
%{ endfor }
# End generated

function pre_req() {
    apt-get --quiet update
    apt-get install  --no-install-recommends -qy vim sshuttle python3-pip fail2ban python3-setuptools
    curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
    pip3 install awscli
}

function associate_eip() {
    # Get EIP id from userdata and dump it to the filesystem
    echo "${eip_id}" > /etc/aws_eip_id
    instance_id=$(/usr/bin/curl -fqs http://169.254.169.254/latest/meta-data/instance-id)
    aws ec2 associate-address --instance-id "$${instance_id}" --allocation-id ${eip_id} --region ${region}
}

function create_users() {
    local default_user
    default_user="tunnel"

    adduser --disabled-password --gecos "" "$${default_user}"
    mkdir "/home/$${default_user}/.ssh"

    for user in "$${!github_urls[@]}"; do
        echo "Pulling key from github for user $${user}"
        echo "# $${user}" >> "/home/$${default_user}/.ssh/authorized_keys"
        curl -sS "$${github_urls[$user]}" >> "/home/$${default_user}/.ssh/authorized_keys"
        echo "" >> "/home/$${default_user}/.ssh/authorized_keys"
    done

    chown -R tunnel:tunnel "/home/$${default_user}/.ssh"
    chmod -R go-rx "/home/$${default_user}/.ssh"

}

function main() {
    pre_req
    associate_eip
    create_users
}

main
