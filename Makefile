IMAGE_TAG ?= capistrano
# All: linux/amd64,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/mips64le,linux/mips64,linux/arm/v7,linux/arm/v6
PLATFORM ?= linux/amd64

ACTION ?= load
PROGRESS_MODE ?= plain
EXTRA_ARGS ?=

.PHONY: docker-build docker-test tag update-tags

docker-build:
	# https://github.com/docker/buildx#building
	docker buildx build \
		--build-arg VCS_REF="$(shell git rev-parse HEAD)" \
		--build-arg BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		--build-arg RELEASE_VERSION="$(shell make version)" \
		--tag $(IMAGE_TAG) \
		--progress $(PROGRESS_MODE) \
		--platform $(PLATFORM) \
		--pull \
		--$(ACTION) \
		$(EXTRA_ARGS) \
		./docker

docker-test:
	docker compose -f ./docker/docker-compose-latest.test.yml up

update-tags:
	git tag -s -f -a -m "latest version ($(shell make version))" latest
	git push origin refs/tags/latest -f

tag:
	@echo "Tagging: $(shell make version)"
	sleep 3
	git tag -s -a -m "$(shell make version)" "$(shell make version)"
	git push origin "refs/tags/$(shell make version)"

version:
	@grep -F "'capistrano'" ./docker/Gemfile | cut -d "'" -f 4
