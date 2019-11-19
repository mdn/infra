FROM python:3

# FIXME: Should really discover the distro version instead of hardcoding
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main"  > /etc/apt/sources.list.d/postgres.list && \
	apt-get update && \
	apt-get -y upgrade && \
	apt-get install -y curl openssl mysql-client postgresql-client-11 && \
	apt-get clean -y && \
	apt-get autoclean -y && \
	apt-get autoremove -y && \
	apt-get purge -y && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN pip3 install awscli --upgrade --no-cache-dir

COPY ./rdsbackup.sh /usr/bin/
RUN mkdir /backup
CMD ["/usr/bin/rdsbackup.sh"]
