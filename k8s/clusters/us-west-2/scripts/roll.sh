#!/bin/bash

asg_name=$1

if [ -z "${asg_name}" ]; then
    echo "Usage: $0 <asg_name>"
    echo "You can get the asg name you need by looking at terraform output"
    exit 1
fi

#asg_name=$(terraform output workers_asg_names)
asg_instances=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names "${asg_name}" --query 'AutoScalingGroups[].Instances[].InstanceId' --output text)

wait_time="180"

for instance in $asg_instances; do
    echo "Terminating Instance ${instance}"
    aws autoscaling terminate-instance-in-auto-scaling-group --no-should-decrement-desired-capacity --instance-id "${instance}"

    rv=$?
    if [ "${rv}" != 0 ]; then
        echo "Something happened and I can't terminate instance: ${instance}.... aborting"
        exit 1
    fi

    echo "Waiting for ${wait_time} seconds before terminating the next instance"
    sleep "${wait_time}"

done
