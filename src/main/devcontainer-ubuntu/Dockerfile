# @file Dockerfile
# @brief A basic devcontainer image for development projects without special needs.
#
# @description The Docker image is configured to serve as a development environment
# ("devcontainer"), making it easy for developers to work on projects without
# worrying about setting up dependencies and tools locally. This image uses Ubuntu
# as the base operating system and includes pre-commit, a tool used for managing
# and maintaining pre-commit hooks (e.g. to run validations before pushing data to
# a remote repository).
#
# This image is link:https://hub.docker.com/r/sommerfeldio/devcontainer-ubuntu[published to DockerHub]
# as ``sommerfeldio/devcontainer-ubuntu``.
#
# == Prerequisites
#
# Having Visual Studio Code (VSCode) and the Dev Container plugin installed are
# essential prerequisites for this development environment. This devcontainer has
# been tested with Docker version 24.0.2 on top of Ubuntu 22.10.
#
# == About the tags and versions
#
# include::ROOT:partial$/docker-tag-strategy.adoc[]
#
# == How to use this image
#
# The dev container configuration is either located under ``.devcontainer/devcontainer.json``
# or stored as a ``.devcontainer.json`` file (note the dot-prefix) in the root of your project.
#
# You can use an image as a starting point for your devcontainer by pulling images from a
# container registry. To use this devcontainer image, add the following lines to your
# devcontainer config file.
#
# This ``.devcontainer/devcontainer.json`` config allows the use of docker containers
# inside the devcontainer and initializes ``pre-commit`` once the container is created.
#
# [source, json]
# ```
# {
# 	"name": "Ubuntu",
#     "image": "sommerfeldio/devcontainer-ubuntu:rc",
#
# 	"features": {
# 		"ghcr.io/devcontainers/features/docker-in-docker:2": {}
# 	},
#
# 	"postCreateCommand": "pre-commit install"
# }
# ```
#
# == See also
#
# For Docker image sources, see https://github.com/sommerfeld-io/docker-images/tree/main/src/main.


FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip=24.0+dfsg-1ubuntu1 \
    && apt-get install -y --no-install-recommends pre-commit=3.6.2-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $USER

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "alias ls='ls -a --color=auto'" >> /home/$USER/.bashrc \
    && echo "alias ll='ls -alF --color=auto'" >> /home/$USER/.bashrc
