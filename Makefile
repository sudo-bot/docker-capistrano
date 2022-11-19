IMAGE_TAG ?= capistrano-laravel

.PHONY: docker-build docker-test tag

docker-build:
	docker build ./docker \
		--build-arg VCS_REF="$(shell git rev-parse HEAD)" \
		--build-arg BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		--build-arg RELEASE_VERSION="$(shell make version)" \
		--tag $(IMAGE_TAG)

docker-test:
	docker-compose -f ./docker/docker-compose-latest.test.yml up

tag:
	@echo "Tagging: $(shell make version)-laravel"
	sleep 3
	git tag -s -a -m "$(shell make version)-laravel" "$(shell make version)-laravel"
	git push origin "refs/tags/$(shell make version)-laravel"

version:
	@grep -F "'capistrano'" ./docker/Gemfile | cut -d "'" -f 4
