IMAGE_TAG ?= capistrano

.PHONY: docker-build docker-test update-tags

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--tag $(IMAGE_TAG)

docker-test:
	docker-compose -f ./docker/docker-compose-latest.test.yml up

update-tags:
	git checkout main
	git tag -s -f -a -m "latest series" latest
	git checkout -
	git push origin refs/tags/latest -f
