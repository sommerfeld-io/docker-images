# @file Dockerfile
# @brief A devcontainer image for projects which mainly rely on Golang.
#
# @description This Docker image symbolizes the development environment container
# for any projects employing link:https://go.dev[Golang]. It derives from Microsoft's
# official Go devcontainer image but some includes supplementary tools. The purpose
# of this image is to function as a devcontainer within Visual Studio Code and is not
# meant to be utilized independently.
#
# This image is link:https://hub.docker.com/r/sommerfeldio/devcontainer-go[published to DockerHub]
# as ``sommerfeldio/devcontainer-go``.
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
# ```
# {
# 	"name": "Go",
#     "image": "sommerfeldio/devcontainer-go:main",
#
# 	"features": {
# 		"ghcr.io/devcontainers/features/docker-in-docker:2": {}
# 	},
#
# 	"postCreateCommand": "pre-commit install"
# }
# ```


FROM mcr.microsoft.com/devcontainers/go:1.21-bullseye
LABEL maintainer="sebastian@sommerfeld.io"

ARG USER=vscode

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN chsh --shell /bin/bash "$USER" \
    && echo "alias ls='ls -a'" >> "/home/$USER/.bashrc" \
    && echo "alias ll='ls -alF'" >> "/home/$USER/.bashrc" \
    && curl https://raw.githubusercontent.com/sebastian-sommerfeld-io/jarvis/main/src/main/install.sh | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends python3-pip=20.3.4-4+deb11u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir pre-commit==3.3.3
