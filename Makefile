IMAGE_TAG ?= capistrano-symfony

.PHONY: docker-build docker-test tag update-tags

docker-build:
	docker build ./docker \
		--build-arg VCS_REF="$(shell git rev-parse HEAD)" \
		--build-arg BUILD_DATE="$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")" \
		--build-arg RELEASE_VERSION="$(shell make version)" \
		--tag $(IMAGE_TAG)

docker-test:
	docker-compose -f ./docker/docker-compose-latest.test.yml up

update-tags:
	git checkout symfony
	git tag -s -f -a -m "latest version ($(shell make version)) with symfony" latest-symfony
	git checkout -
	git push origin refs/tags/latest-symfony -f

tag:
	@echo "Tagging: $(shell make version)-symfony"
	git checkout symfony
	git tag -s -a -m "$(shell make version)-symfony" "$(shell make version)-symfony"
	git checkout -
	git push origin "refs/tags/$(shell make version)-symfony"

version:
	@grep -F "'capistrano'" ./docker/Gemfile | cut -d "'" -f 4
