#!make

MAKEFLAGS += --always-make

EGND_DOCKER_IMAGE=egnd/docker
IMG_VERSION=local

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

########################################################################################################################

owner: ## Reset folder owner
	sudo chown --changes -R $$(whoami) ./
	@echo "Success"

check-conflicts: ## Find git conflicts
	@if grep -rn '^<<<\<<<< ' .; then exit 1; fi
	@if grep -rn '^===\====$$' .; then exit 1; fi
	@if grep -rn '^>>>\>>>> ' .; then exit 1; fi
	@echo "All is OK"

check-todos: ## Find TODO's
	@if grep -rn '@TO\DO:' .; then exit 1; fi
	@echo "All is OK"

check-master: ## Check for latest master in current branch
	@git remote update
	@if ! git log --pretty=format:'%H' | grep $$(git log --pretty=format:'%H' -n 1 origin/master) > /dev/null; then exit 1; fi
	@echo "All is OK"

image: _env ## Create a proxy image
	docker build --tag $(EGND_DOCKER_IMAGE):$(IMG_VERSION) . 

scan: images  ## Scan proxy image for vulnerabilities
	docker scan --dependency-tree --severity=high $(EGND_DOCKER_IMAGE)

lint: ## Validate Dockerfile
	docker run --rm -i ghcr.io/hadolint/hadolint:latest-alpine /bin/hadolint --ignore=DL3008 - < ./Dockerfile

test: ## Test container
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) docker --version
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) docker-compose version
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) docker buildx version
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) make -v
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) envsubst -V
	docker run --rm $(EGND_DOCKER_IMAGE):$(IMG_VERSION) grep -V
