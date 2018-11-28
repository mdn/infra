# https://github.com/fr3nd/docker-percona-toolkit/blob/master/Dockerfile
FROM debian:jessie-slim

RUN apt-get update && apt-get install -y \
      libdbd-mysql-perl \
      libdbi-perl \
      libio-socket-ssl-perl \
      libterm-readkey-perl \
      perl \
      wget \
      && rm -rf /usr/share/doc/* && \
      rm -rf /usr/share/info/* && \
      rm -rf /tmp/* && \
      rm -rf /var/tmp/*

WORKDIR /tmp
RUN wget https://www.percona.com/downloads/percona-toolkit/3.0.12/binary/debian/jessie/x86_64/percona-toolkit_3.0.12-1.jessie_amd64.deb && \
    dpkg -i percona-toolkit*.deb && \
    rm -f percona-toolkit*.deb

COPY run.sh /
WORKDIR /

CMD /run.sh
