IMAGE_TAG ?= capistrano-laravel
# All: linux/amd64,linux/arm64,linux/riscv64,linux/ppc64le,linux/s390x,linux/386,linux/mips64le,linux/mips64,linux/arm/v7,linux/arm/v6
PLATFORM ?= linux/amd64

ACTION ?= load
PROGRESS_MODE ?= plain

.PHONY: docker-build docker-test tag

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
		./docker

docker-test:
	docker-compose -f ./docker/docker-compose-latest.test.yml up

tag:
	@echo "Tagging: $(shell make version)-laravel"
	sleep 3
	git tag -s -a -m "$(shell make version)-laravel" "$(shell make version)-laravel"
	git push origin "refs/tags/$(shell make version)-laravel"

version:
	@grep -F "'capistrano'" ./docker/Gemfile | cut -d "'" -f 4
