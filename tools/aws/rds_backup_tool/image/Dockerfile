FROM python:3

RUN apt-get update && apt-get -y upgrade && apt-get install -y curl openssl mysql-client postgresql-client
RUN pip3 install awscli --upgrade

COPY ./rdsbackup.sh /usr/bin/
RUN mkdir /backup
CMD ["/usr/bin/rdsbackup.sh"]
