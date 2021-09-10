# docker with additional packages

[![Pipeline](https://github.com/egnd/docker/actions/workflows/pipeline.yml/badge.svg)](https://github.com/egnd/docker/actions?query=workflow%3APipeline)
![GitHub](https://img.shields.io/github/license/egnd/docker)
![Docker Stars](https://img.shields.io/docker/stars/egnd/docker)
![Docker Pulls](https://img.shields.io/docker/pulls/egnd/docker)
![Image Size](https://img.shields.io/docker/image-size/egnd/docker/docker)

### Features inside:
* docker
* docker-compose
* docker buildx
* make
* envsubst
* grep

### Examples:
1. Docker-compose
```yml
job name:
  image: egnd/docker
  services:
    - docker:dind
  script:
    - docker-compose version
```
2. Docker buildx
```yml
job name:
  image: egnd/docker
  services:
    - docker:dind
  script:
    - docker buildx create --driver=docker-container --use
    - docker buildx build --push --progress=plain
        --build-arg SOME_ARG=some-value
        --platform linux/arm,linux/arm64,linux/amd64 
        --tag simeimage:latest
        --cache-from type=registry,ref=simeimage:cache
        --cache-to type=registry,ref=simeimage:cache,mode=max
        .
```
