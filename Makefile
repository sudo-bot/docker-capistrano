.PHONY: docker-build docker-test

docker-build:
	docker build ./docker \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`

docker-test:
	docker-compose -f ./docker/docker-compose-latest.test.yml up
