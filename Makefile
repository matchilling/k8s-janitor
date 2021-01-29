.PHONY: default
default: help;

STACK_SLUG := matchilling/k8s-janitor
STACK_VERSION := latest

help:                ## Show this help
	@echo '----------------------------------------------------------------------'
	@echo $(STACK_SLUG)
	@echo '----------------------------------------------------------------------'
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'
	@echo '----------------------------------------------------------------------'

build:               ## Build the container
	@docker build \
		--file Dockerfile \
		--tag "${STACK_SLUG}:${STACK_VERSION}" .

delete:
	@docker rmi "${STACK_SLUG}:${STACK_VERSION}"

release:             ## Push image to docker registry
	@docker push "${STACK_SLUG}:${STACK_VERSION}"

run-local:           ## Run locally
	docker run \
		--env MATTERMOST_URL=$$MATTERMOST_URL \
		--env NAMESPACE=$$NAMESPACE \
		--interactive \
		--rm \
		--tty \
		--volume $$HOME/.kube/config:/root/.kube/config \
		"${STACK_SLUG}:${STACK_VERSION}" bash

run-k8s-interactive: ## Run on K8S
	kubectl run \
		--env MATTERMOST_URL=$$MATTERMOST_URL \
		--image-pull-policy=Always \
		--image="${STACK_SLUG}:${STACK_VERSION}" \
		--namespace $$NAMESPACE \
		--restart=Never \
		--rm \
		--serviceaccount=$$SERVICE_ACCOUNT \
		--stdin \
		--tty \
		k8s-janitor --
