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
#     "image": "sommerfeldio/devcontainer-ubuntu:main",
#
# 	"features": {
# 		"ghcr.io/devcontainers/features/docker-in-docker:2": {}
# 	},
#
# 	"postCreateCommand": "pre-commit install"
# }
# ```


FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN chsh --shell /bin/bash "$USER" \
    && echo "alias ls='ls -a'" >> "/home/$USER/.bashrc" \
    && echo "alias ll='ls -alF'" >> "/home/$USER/.bashrc" \
    && curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/install.sh | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3-pip=22.0.2+dfsg-1ubuntu0.4 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir pre-commit==3.3.3
