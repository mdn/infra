#!/bin/bash

set -u
set -x

HOSTNAME=$(curl -fsq http://169.254.169.254/latest/meta-data/hostname)
REGION=$(curl -fqs http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
CLUSTER_NAME=$(cat /etc/eks/cluster_name)

# Setup kubeconfig
aws eks update-kubeconfig --region "${REGION}" --name "${CLUSTER_NAME}"

export KUBECONFIG="/root/.kube/config"

kubectl cordon "${HOSTNAME}"
kubectl drain "${HOSTNAME}" --ignore-daemonsets --grace-period=30 --force

sleep 10
