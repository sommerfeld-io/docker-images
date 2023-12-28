# @file Dockerfile
# @brief Dockerfile for generating AsciiDoc Documentation based on inline documentation.
#
# @description This Dockerfile is designed to generate AsciiDoc documentation for a
# specific Antora module based on inline documentation from Dockerfiles, Bash scripts,
# and GitHub Actions workflows.
#
# The generated documentation provides a comprehensive guide for developers and users,
# enhancing the understanding of the codebase and facilitating smoother collaboration.
#
# NOTE: This image is intentionally running as root to make sure it can be used inside
# Github Actions workflows without permission errors.
#
# == About the tags and versions
#
# include::ROOT:partial$/docker-tag-strategy.adoc[]
#
# == How to use this image
# To use the image run the following command from a bash file.
#
# [source, bash]
# ```
# docker run --rm --user "$(id -u):$(id -g)"  --volume /etc/timezone:/etc/timezone:ro  --volume /etc/localtime:/etc/localtime:ro  --volume "$(pwd):/project"  --workdir "/project"  sommerfeldio/source2docs:latest
# ```
#
# NOTE: Run this image from the root of your project. Do not change the volume bind from
# ``/project`` to anything else because the scripts inside the action expect this folder
# to exist and to contain your projects data.
#
# == See also
#
# The base image is link:https://hub.docker.com/r/bitnami/git[``bitnami/git``]. See
# link:https://docs.bitnami.com/tutorials/understand-rolling-tags-containers[Bitname Docs]
# for details on Bitnami's tagging system and how you can use it to identify different
# versions of its Docker container images.
#
# The xref:AUTO-GENERATED:src/main/docker/source2docs/entrypoint-sh.adoc[src/main/docker/source2docs/entrypoint.sh]
# script serves as the entrypoint for this Docker image.


FROM bitnami/git:2.42.0-debian-11-r23
LABEL maintainer="sebastian@sommerfeld.io"

RUN groupadd -g 1000 sebastian \
    && useradd -r -u 1000 -g sebastian sebastian \
    && chsh -s /bin/bash sebastian \
    && apt-get update \
    && apt-get install -y --no-install-recommends make=4.3-4.1 \
    && apt-get install -y --no-install-recommends gawk=1:5.1.0-1 \
    && apt-get install -y --no-install-recommends ruby-full=1:2.7+2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --recursive https://github.com/reconquest/shdoc /tmp/shdoc

WORKDIR /tmp/shdoc

RUN make install \
    && chown sebastian:sebastian "$(which shdoc)" \
    && gem install kramdown-asciidoc:2.1.0

USER sebastian

COPY assets/.gitconfig /home/sebastian/.gitconfig
COPY . /source2docs

# hadolint ignore=DL3002
USER root

ENTRYPOINT ["/source2docs/entrypoint.sh"]
