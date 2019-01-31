deploy: render-backupstoragelocation render-volumesnapshotlocation

debug: debug-render-backupstoragelocation debug-render-volumesnapshotlocation

debug-render-backupstoragelocation: check-env
	j2 ark-backupstoragelocation.yaml.j2

debug-render-volumesnapshotlocation: check-env
	j2 ark-volumesnapshotlocation.yaml.j2

render-backupstoragelocation: check-env
	j2 ark-backupstoragelocation.yaml.j2 | kubectl apply -f -

render-volumesnapshotlocation: check-env
	j2 ark-volumesnapshotlocation.yaml.j2 | kubectl apply -f -

check-env:
ifndef AWS_REGION
	$(error AWS_REGION is undefined)
endif

ifndef ARK_BUCKET
	$(error ARK_BUCKET is undefied)
endif

.PHONY: render-backupstoragelocation render-volumesnapshotlocation
