TAG ?= latest
REGISTRY_ID ?= 152617774363
REPOSITORY_REGION ?= eu-central-1
APP_NAME ?= testapp
ENV_NAME ?= testenv
REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/${APP_NAME}-${ENV_NAME}
# -f ./Dockerfile .
.PHONY: build
build:
	sudo $(MAKE) docker-login
	sudo docker build -t $(REPO_NAME):$(TAG) .
	sudo docker push $(REPO_NAME):$(TAG)

.PHONY: docker-login
docker-login:
	aws ecr get-login-password --region $(REPOSITORY_REGION) | docker login --username AWS --password-stdin $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com