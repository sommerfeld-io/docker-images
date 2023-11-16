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


FROM ubuntu:23.10
LABEL maintainer="sebastian@sommerfeld.io"

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq=1.6-3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
