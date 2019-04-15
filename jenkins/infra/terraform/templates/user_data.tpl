#!/bin/bash

set -xu

BACKUP_DIR="${backup_dir}"
BACKUP_BUCKET="${backup_bucket}"
JENKINS_BACKUP_DMS="${jenkins_backup_dms}"
NGINX_HTPASSWD="${nginx_htpasswd}"
PAPERTRAIL_HOST="${papertrail_host}"
PAPERTRAIL_PORT="${papertrail_port}"
DATADOG_KEY="${datadog_key}"
DATADOG_HOSTNAME="${datadog_hostname}"
EIP_ID="${eip_id}"

die() {
    echo "$*" 1>&2
    exit 1
}

restore-backup-set() {
    systemctl stop jenkins
    echo "Restoring from backup"
    aws s3 sync --delete --exclude=.initial-sync "s3://$BACKUP_BUCKET/" "$BACKUP_DIR/" --quiet
    chown -R jenkins:jenkins "$BACKUP_DIR"
    touch "$BACKUP_DIR/.initial-sync"
    systemctl start jenkins
}

ci-restore() {
    systemctl stop jenkins
    # List all backups in proper order
    ALL_BACKUPS=$(find $$BACKUP_DIR -maxdepth 1 -type d   -name 'FULL*' -o -name 'DIFF*' | sort -t- -k2)

    # Find the last full backup
    LAST_FULL=$(basename "$(echo "$$ALL_BACKUPS" | grep FULL | tail -n1)")

    # And all following incrementals
    INCREMENTALS=$(echo "$$ALL_BACKUPS" | sed -e "0,/$LAST_FULL/d" | xargs -n1 basename)

    # Recover from latest backup (full + incrementals)
    for BACKUP in $$LAST_FULL $$INCREMENTALS; do
        echo "Restoring from $$BACKUP_DIR/$BACKUP/"
        su - jenkins -c "rsync -av $BACKUP_DIR/$BACKUP/ /var/lib/jenkins/"
    done
    systemctl start jenkins
}

lock() {
    local prefix=$$1
    local lock_file="/var/lock/$$prefix.lock"

    # create lockfile
    eval "exec 200>$$lock_file"
    # acquire the lock
    flock -n 200 \
        && return 0 \
        || return 1
}

associate_eip() {
    echo "$${EIP_ID}" > /etc/aws_eip_id
    instance_id=$(/usr/bin/curl -fqs http://169.254.169.254/latest/meta-data/instance-id)

    aws ec2 associate-address --instance-id "$${instance_id}" --allocation-id "$${EIP_ID}" --region ${region}
}

main() {
    # Make sure backups dont run when trying to restore
    lock "backup_jenkins"

    # Setup git and ansible
    apt-get update
    apt-get install --yes git ansible

    # run ansible
    git clone https://github.com/mdn/ansible-jenkins.git /tmp/ansible-jenkins || die "Failed to git clone"
    cd /tmp/ansible-jenkins && \
        ansible-playbook site.yml -e "jenkins_backup_directory="$${BACKUP_DIR}" jenkins_backup_bucket="$${BACKUP_BUCKET}" \
                                        jenkins_backup_dms="$${JENKINS_BACKUP_DMS}" nginx_htpasswd="$${NGINX_HTPASSWD}" \
                                        papertrail_host="$${PAPERTRAIL_HOST}" papertrail_port="$${PAPERTRAIL_PORT}" \
                                        datadog_key="$${DATADOG_KEY}" datadog_hostname="$${DATADOG_HOSTNAME}"" \
        || die "Failed to run ansible"

    echo "Setting EIP"
    associate_eip || die "Failed to associate EIP"

    echo "Restoring backup sets to $${BACKUP_DIR}"
    restore-backup-set || die "Failed to restore backup set to $${BACKUP_DIR}"

    echo "Restoring jenkins"
    ci-restore || die "Failed to restore jenkins"
}

main
