ARG DOCKER_VERSION=latest

FROM docker:${DOCKER_VERSION}

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx

RUN apk add -q --no-cache docker-compose make gettext grep

ENV DOCKER_DRIVER overlay2
ENV DOCKER_HOST tcp://docker:2375
ENV DOCKER_TLS_CERTDIR ""
