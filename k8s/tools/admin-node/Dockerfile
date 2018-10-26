FROM python:3

ENV LANG C.UTF-8

RUN apt-get update\
        && apt-get install -y --no-install-recommends mysql-client openssl\
        && pip install awscli --upgrade \
        && apt-get clean -y \
        && apt-get autoclean -y \
        && apt-get autoremove -y \
        && apt-get purge -y \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache/* \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/
