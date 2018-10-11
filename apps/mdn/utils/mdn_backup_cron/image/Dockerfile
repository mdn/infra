from python:3-slim

ENV AWS_ACCESS_KEY_ID setme
ENV AWS_SECRET_ACCESS_KEY setme
ENV LOCAL_DIR /data
ENV REMOTE_DIR /backups/
ENV BUCKET s3://mdn-efs-backup

# set to either PUSH or PULL
ENV PUSH_OR_PULL PUSH

# install packages
RUN apt-get update && apt-get -y upgrade && apt-get install -y python3-pip curl
RUN pip3 install pip --upgrade
RUN pip3 install awscli --upgrade

RUN groupadd --gid 1000 kuma
RUN useradd -ms /bin/bash --uid 1000 --gid 1000 kuma
USER kuma:kuma

WORKDIR /mdnsync

ADD mdn_sync.sh /mdnsync/mdn_sync.sh
CMD ["/mdnsync/mdn_sync.sh"]
