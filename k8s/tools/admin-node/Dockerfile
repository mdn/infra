FROM ubuntu:18.04

RUN apt-get update\
        && apt-get install -y --no-install-recommends mysql-client python-setuptools python-pip\
        && pip install awscli \
        && apt-get clean -y \
        && apt-get autoclean -y \
        && apt-get autoremove -y \
        && apt-get purge -y \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/
