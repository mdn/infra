#!/bin/bash

set -u

install_ssm() {
    yum install -y amazon-ssm-agent
    systemctl start amazon-ssm-agent
}

install_ssm
