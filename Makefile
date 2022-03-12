IMAGE_TAG ?= capistrano

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
	git checkout main
	git tag -s -f -a -m "latest version ($(shell make version))" latest
	git checkout -
	git push origin refs/tags/latest -f

tag:
	@echo "Tagging: $(shell make version)"
	git checkout main
	git tag -s -a -m "$(shell make version)" "$(shell make version)"
	git checkout -
	git push origin "refs/tags/$(shell make version)"

version:
	@grep -F 'capistrano' ./docker/Gemfile | cut -d "'" -f 4
