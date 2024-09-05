# @file Dockerfile
# @brief Extend the vhs Docker image to enable the recording of Docker commands.
#
# @description This image extends the official VHS Docker image to enable the recording of Docker
# commands. The official image is not able to record Docker commands.
#
# * Image on DockerHub: https://hub.docker.com/r/sommerfeldio/vhs4docker
# * ``Dockerfile`` on GitHub: https://github.com/sommerfeld-io/docker-images/tree/main/src/main/vhs4docker
# * link:https://github.com/charmbracelet/vhs[Official VHS repositoy] on GitHub
#
# This extended ``sommerfeldio/vhs4docker` image comes with a Docker CLI, so it can run Docker
# commands. However, this image does not run containers on its own (so it is not comparable to
# Docker-in-Docker). You need to mount the hosts ``docker.sock`` into the container to run Docker
# commands.
#
# The official VSH image is based on Debian. To install Docker, we followed the instructions from
# https://docs.docker.com/engine/install/debian/#installation-methods. However, we only installed
# ``docker-ce-cli`` to allow interacting with a Docker Engine. We did not install the full Docker
# engine.
#
# == Usage
#
# For information on how to get started with VHS, see the official VHS documentation at
# https://github.com/charmbracelet/vhs. At this point, we will only cover the Docker-specific
# aspects. Still, a ``demo.tape`` file is available in this repository next to the ``Dockerfile``.
#
# === Record Docker command
#
# First pull the image you want to record from the Container Registry. Then run the image.
# Otherwise the recording would contain lines from the pull command (which most likely is not
# desired). Normally, only the output from the ``docker run command`` should be recorded.
#
# TODO For the ``demo.tape`` file, see .
#
# [source, bash]
# ....
# # we assume, that the tape file uses: hello-world:latest
# docker pull hello-world:latest
#
# docker run --rm \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   --volume "$(pwd):$(pwd)" \
#   --workdir "$(pwd)" \
#   sommerfeldio/vhs4docker:latest demo.tape
# ....
#
# === Record Docker that print a directory listing
#
# To record e.g. ``docker run --rm -v ""$(pwd):/vhs4docker"" -w "$(pwd)" alpine:latest ls -alF``, you need
# to specify this command in a ``.tape`` file. The ``docker run ...`` command for vhs4docker remains
# the same. For information about tape files, see link:https://github.com/charmbracelet/vhs[docs of the official base image].
#
# Remember to mount the same directory into the vhs4docker container. Otherwise the command from
# the tape file cannot access the files you expect.
#
# TODO For the ``ls.tape`` file, see .
#
# [source, bash]
# ....
# # we assume, that the tape file uses: alpine:latest
# docker pull alpine:latest
#
# docker run --rm \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   --volume "$(pwd):$(pwd)" \
#   --workdir "$(pwd)" \
#   sommerfeldio/vhs4docker:latest ls.tape
# ....
#
# === Use with Docker Compose
#
# TODO For the ``ls.tape`` file, see .
#
# [source, bash]
# ....
# TODO
# ....
#
# === Build the image locally
#
# [source, bash]
# ....
# docker build -t local/vhs4docker:dev .
#
# # we assume, that the tape file uses: hello-world:latest
# docker pull hello-world:latest
#
# docker run --rm \
#   --volume /var/run/docker.sock:/var/run/docker.sock \
#   --volume "$(pwd):$(pwd)" \
#   --workdir "$(pwd)" \
#   local/vhs4docker:dev demo.tape
# ....
#
# == Contact
#
# Feel free to contact me via sebastian@sommerfeld.io or visit https://www.sommerfeld.io.


FROM ghcr.io/charmbracelet/vhs:v0.7.2
LABEL maintainer="sebastian@sommerfeld.io"


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates=20230311 \
    && apt-get install -y --no-install-recommends curl=7.88.1-10+deb12u7 \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli=5:27.2.0-1~debian.12~bookworm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
