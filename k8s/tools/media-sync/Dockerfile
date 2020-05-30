FROM python:3-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl && \
	pip install --no-cache --no-cache-dir awscli && \
	mkdir -p /app && \
	apt-get purge -y --auto-remove && \
	apt-get clean -y && \
	apt-get autoclean -y && \
	rm -rf /var/lib/apt/lists/* /var/lib/{apt,dpkg,cache,log}/ /var/tmp/*

WORKDIR /app

COPY ./media-sync.sh /app
CMD [ "/app/media-sync.sh" ]
