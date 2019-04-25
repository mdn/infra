#!/bin/bash

set -u

lifecycled_version="v3.0.2"

yum install -y amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install the binary
curl -Lf -o /usr/bin/lifecycled \
        https://github.com/buildkite/lifecycled/releases/download/$${lifecycled_version}/lifecycled-linux-amd64
chmod +x /usr/bin/lifecycled

# Install the systemd service
#touch /etc/lifecycled
#curl -Lf -o /etc/systemd/system/lifecycled.service \
#        https://raw.githubusercontent.com/buildkite/lifecycled/$${lifecycled_version}/init/systemd/lifecycled.unit
