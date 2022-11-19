FROM ruby:3-alpine3.16

ARG RELEASE_VERSION

# Metadata params
ARG VCS_REF
ARG BUILD_DATE
ARG RELEASE_VERSION

WORKDIR /deploy

COPY Gemfile ./

RUN apk add --update --no-cache openssh-client make ruby-dev gcc musl-dev && \
    gem install bundler --user-install && \
    bundle install --no-cache && \
    apk del gcc make musl-dev ruby-dev && \
    rm -rf /usr/local/bundle/cache /root/.bundle

# Metadata
LABEL org.label-schema.vendor="Sudo-Bot" \
    org.label-schema.url="https://github.com/capistrano/capistrano#readme" \
    org.label-schema.name="capistrano" \
    org.label-schema.description="A capistrano image to deploy using SSH and Git" \
    org.label-schema.version=${RELEASE_VERSION} \
    org.label-schema.vcs-url="https://github.com/capistrano/capistrano.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.schema-version="1.0" \
    \
    com.docker.extension.publisher-url="https://github.com/sudo-bot" \
    \
    org.opencontainers.image.title="Docker autodiscover, autoconfig web server" \
    org.opencontainers.image.description="A capistrano image to deploy using SSH and Git" \
    org.opencontainers.image.authors="williamdes@wdes.fr" \
    org.opencontainers.image.url="https://github.com/capistrano/capistrano#readme" \
    org.opencontainers.image.documentation="https://github.com/capistrano/capistrano#readme" \
    org.opencontainers.image.source="https://github.com/capistrano/capistrano" \
    org.opencontainers.image.vendor="Sudo-Bot" \
    org.opencontainers.image.licenses="MPL-2.0" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.version=${RELEASE_VERSION} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.ref.name="latest"
