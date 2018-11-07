# MDN RDS Backups

## Context

MDN uses an AWS RDS instance for production that is replicated to a read-only
RDS replica used by the standby cluster. The RDS backups are performed on the
read-only RDS replica so they don't affect the performance of the production
instance, and are implemented using the `mdn-rds-backup` Kubernetes `CronJob`
that runs within the `mdn-prod` namespace of the standby cluster. The backup
is performed daily, and results in a roughly 3GB compressed and encrypted
file stored within the `backups/developer_mozilla_org` folder of the
`mdn-rds-backup-7752d5ca6f3744a0` S3 bucket. The `CronJob` uses the
`mdnwebdocs/mdn-rds-backup` image on DockerHub, and is monitored by a
Dead Man's Snitch.

The backups within the `mdn-rds-backup-7752d5ca6f3744a0` S3 bucket are
governed by a lifecycle rule that moves them to AWS Glacier after 30 days.

## Building and pushing the image

From the `apps/mdn/utils/rds_backup/image` directory, simply run:

```bash
./build.sh
```

That will build and push the image to `mdnwebdocs/mdn-rds-backup` on DockerHub.

## Configuration

Most of these values are acquired from the Kubernetes `Secret` resource
`mdn-rds-backup-secrets`.

- `DBTYPE`: accepts either of the following values: `MYSQL` or `PGSQL`
- `DBNAME`: name of the database to use in the connection string
- `DBUSER`: MySQL or PostgreSQL username
- `DBPASSWORD`: MySQL or PostgreSQL password
- `DBHOST`: MySQL or PostgreSQL host without the port number
- `DBPORT`: MySQL or PostgreSQL port number
- `BACKUP_CMD_PARAMS`: additional parameters to pass to backup command for psql/mysql
- `BACKUP_BUCKET`: where to write backup file, includes s3:// prefix
- `BACKUP_DIR`: directory in the container mapped to EBS volume
- `BACKUP_PASSWORD`: symmetric encryption password
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `DEADMANSSNITCH_URL`

## Using in Kubernetes

To start the `mdn-rds-backup` `CronJob` in the standby cluster, first ensure
that you've deployed the `mdn-rds-backup-secrets` Kubernetes `Secret` resource,
and then:

```bash
cd apps/mdn/mdn-aws/k8s
source regions/germany/prod.mm.sh
make k8s-rds-backup-cron
```

## Decrypting a database archive

You can download the backup using either the AWS web console, or the AWS cli.

```bash
aws s3 cp s3://mdn-rds-backup-7752d5ca6f3744a0/backups/developer_mozilla_org/developer_mozilla_org.2018-11-02.sql.gz.aes ./some_local_dir
```

Make sure you're using `openssl` version 1.1 or later (`openssl version`).

```bash
# stream directly to dbms
openssl aes-256-cbc -d -in developer_mozilla_org.2018-11-02.sql.gz.aes -pass pass:foobar123 | zcat | mysql ...
```

The password is stored in `credentials.yml` under the key `backup_gpg_password`.
