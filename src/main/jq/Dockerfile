# @file Dockerfile
# @brief Docker image for jq.
#
# @description The link:https://hub.docker.com/r/sommerfeldio/jq[``sommerfeldio/jq``]
# image ships with link:https://stedolan.github.io/jq[jq] which is a lightweight and
# flexible command-line JSON processor.
#
# == About the tags and versions
#
# include::ROOT:partial$/docker-tag-strategy.adoc[]
#
# == See also
#
# For Docker image sources, see https://github.com/sommerfeld-io/docker-images/tree/main/src/main.


FROM ubuntu:24.04
LABEL maintainer="sebastian@sommerfeld.io"

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq=1.7.1-3build1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
