# MDN EFS <--> S3 Backup/Restore

## Context

MDN runs three Kubernetes `CronJob`s related to EFS volumes:

1. `mdn-backup-prod`, which runs in the main cluster within the `mdn-prod`
namespace, performs an hourly backup of `/mdn/www/` on the production EFS
volume into the `backups/mdn` folder of an S3 bucket. It provides an hourly
backup of the production EFS volume, and is monitored by a Dead Man's Snitch.
2. `mdn-restore-prod`, which runs in the standby cluster within the `mdn-prod`
namespace, syncs (again hourly) the `backups/mdn` folder of that same S3 bucket
into `/mdn/www` on the standby EFS volume. It keeps the standby EFS volume
synchronized with the production EFS volume, and is monitored by a Dead Man's
Snitch.
3. `mdn-s3-sync-stage`, which runs in the main cluster within the `mdn-stage`
namespace, syncs (again hourly) the `backups/efs` folder (not to be confused
with the `backups/mdn` folder) of that same S3 bucket into `/mdn/www` on the
stage EFS volume. The `backups/efs` folder is populated manually, so currently
this mostly does nothing. It is not essential and therefore is not monitored
by a Dead Man's Snitch.

All of these `CronJob`s use the `mdnwebdocs/mdn-backup` image on DockerHub.

## Building and pushing the image

From the `apps/mdn/utils/efs_backup/image` directory, simply run:

```bash
./build.sh
```

That will build and push the image to `mdnwebdocs/mdn-backup` on DockerHub.

## Configuration

- `LOCAL_DIR` - the directory *in the running container* that we'll push or pull from.
- `BUCKET` - the bucket where backup data is stored.
- `REMOTE_DIR` - the directory in `$BUCKET` that we'll push or pull from.
- `PUSH_OR_PULL` - set to either `PUSH` or `PULL`
  - `PUSH` - recursively sync from `$LOCAL_DIR` to `$BUCKET$REMOTE_DIR`
  - `PULL` - recursively sync from `$BUCKET$REMOTE_DIR` to `$LOCAL_DIR`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
	- credentials for the `mdn-efs-backup` user
	- **or**, credentials for a user with the following attached policy:
- `SYNC_COMMAND` - defaults to `aws s3 sync`, use this to send in additional params etc.

## Using in Kubernetes

To start the `mdn-backup-prod` `CronJob` in the main cluster, first ensure
that you've deployed the `mdn-backup-secrets` Kubernetes `Secret` resource,
and then:

```bash
cd apps/mdn/mdn-aws/k8s
source regions/oregon/prod.sh
make k8s-backup-cron
```

To start the `mdn-restore-prod` `CronJob` in the standby cluster, first ensure
that you've deployed the `mdn-backup-secrets` Kubernetes `Secret` resource,
and then:

```bash
cd apps/mdn/mdn-aws/k8s
source regions/germany/prod.mm.sh
make k8s-restore-cron
```

To start the `mdn-s3-sync-stage` `CronJob` in the main cluster, first ensure
that you've deployed the `mdn-backup-secrets` Kubernetes `Secret` resource,
and then:

```bash
cd apps/mdn/mdn-aws/k8s
source regions/oregon/stage.sh
make k8s-sync-from-s3-cron
```
