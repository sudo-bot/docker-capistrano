FROM ruby:3-alpine3.14

ARG RELEASE_VERSION="3.11.0"

# Metadata params
ARG VCS_REF
ARG BUILD_DATE

WORKDIR /deploy

COPY Gemfile ./

RUN apk add --update --no-cache openssh-client make ruby-dev gcc musl-dev && \
    gem install bundler --user-install && \
    bundle install && \
    apk del gcc make musl-dev ruby-dev

# Metadata
LABEL org.label-schema.vendor="Sudo-Bot" \
    org.label-schema.url="https://github.com/capistrano/capistrano#readme" \
    org.label-schema.name="capistrano" \
    org.label-schema.description="A capistrano image" \
    org.label-schema.version=${RELEASE_VERSION} \
    org.label-schema.vcs-url="https://github.com/capistrano/capistrano.git" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.schema-version="1.0"
