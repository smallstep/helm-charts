#!/bin/sh

all: artifacts

# Version flags
VERSION ?= $(shell [ -d .git ] && git describe --tags --always --dirty="-dev")
VERSION := $(shell echo $(VERSION) | sed 's/^v//')
NOT_RC  := $(shell echo $(VERSION) | grep -v -e -rc)

# If TRAVIS_TAG is set then we know this ref has been tagged.
ifdef TRAVIS_TAG
	ifeq ($(NOT_RC),)
		PUSHTYPE=release-candidate
	else
		PUSHTYPE=release
	endif
else
	PUSHTYPE=master
endif

#########################################
# Building Docker Image
#########################################

DOCKER_BUILD=$Q docker build -t smallstep/$(1):latest -f $(2) .

docker: Dockerfile
	$(call DOCKER_BUILD,step-ca-bootstrap,Dockerfile)

.PHONY: docker

#################################################
# Releasing Docker Images
#################################################

DOCKER_TAG=docker tag smallstep/$(1):latest smallstep/$(1):$(2)
DOCKER_PUSH=docker push smallstep/$(1):$(2)

docker-tag:
	$(call DOCKER_TAG,step-ca-bootstrap,$(VERSION))

docker-push-tag: docker-tag
	$(call DOCKER_PUSH,step-ca-bootstrap,$(VERSION))

docker-push-tag-latest:
	$(call DOCKER_PUSH,step-ca-bootstrap,latest)

# Rely on DOCKER_USERNAME and DOCKER_PASSWORD being set inside the CI or
# equivalent environment
docker-login:
	$Q echo "$(DOCKER_PASSWORD)" | docker login -u="$(DOCKER_USERNAME)" --password-stdin

.PHONY: docker-login docker-tag docker-push-tag docker-push-tag-latest

#################################################
# Targets for pushing the docker images
#################################################

# For all builds we build the docker container
docker-master: docker

# For all builds with a release candidate tag
docker-release-candidate: docker-master docker-login docker-push-tag

# For all builds with a release tag
docker-release: docker-release-candidate docker-push-tag-latest

.PHONY: docker-master docker-release-candidate docker-release

#################################################
# Targets for creating step artifacts
#################################################

# This command is called by travis directly *after* a successful build
artifacts: docker-$(PUSHTYPE)

.PHONY: artifacts
