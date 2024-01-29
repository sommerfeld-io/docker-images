# @file Dockerfile
# @brief Extension of the official JetBrains Qodana image to allow Asciidoc validation.
#
# @description This Docker image is set up to offer an installation of Qodana,
# utilizing the official image provided by JetBrains. In addition to the base image,
# this customized Docker image includes specific plugins that enable validation for
# AsciiDoc and grammar. Essentially, it extends the functionality of the original
# JetBrains image by incorporating these additional plugins for more comprehensive
# validation capabilities.
#
# == Prerequisites
#
# This image has been developed and tested with Docker version 24.0.2 on top of Ubuntu 22.10.
#
# == About the tags and versions
#
# This Docker image follows a tagging convention based on semantic versioning. Each
# stable version of the image is tagged with a specific semantic version (e.g.
# ``:v0.2.0``), while the ``:latest`` tag always points to the most recent stable
# version.
#
# Unstable versions are marked with a suffix (``-alpha.0``, ``-beta.0`` or ``-rc.0``).
# These versions usually are used for development or testing purposes. These versions
# are not recommended for production use. ``:latest`` never points to an unstable
# pre-release.
#
# The image may have a ``:main`` tag, which represents an unstable build. These versions
# come from CI builds and/or nightly builds and are useful for continuous integration
# and testing purposes. The ``:main`` tag is never meant for production use and may
# contain experimental features or unresolved issues.
#
# == How to use this image
#
# [source, bash]
# ```
# docker build -t local/qodana:dev .
#
# # Run the previously built local image
# touch qodana.sarif.json && docker run --rm -it -p 8080:8080 \
#   --volume "$(pwd):/data/project" \
#   --volume "$(pwd)/qodana.sarif.json:/data/results/qodana.sarif.json:rw" \
#   local/qodana:dev \
#       --property=idea.suppressed.plugins.id=com.intellij.gradle,org.jetbrains.plugins.gradle \
#       --show-report
#
# # Run the image from DockerHub
# touch qodana.sarif.json && docker run --rm -it -p 8080:8080 \
#   --volume "$(pwd):/data/project" \
#   --volume "$(pwd)/qodana.sarif.json:/data/results/qodana.sarif.json:rw" \
#   sommerfeldio/qodana:rc \
#       --property=idea.suppressed.plugins.id=com.intellij.gradle,org.jetbrains.plugins.gradle \
#       --show-report
# ```
#
# Creating the ``qodana.sarif.json`` file is needed to allow mounting the file into the container.
# Without this, the report stays hidden in the container and is not available for e.g. uploading
# to GitHub Code scanning alerts. Without touching the file first, Docker (as per its default
# behavior) creates a folder which causes Qodana to crash.
#
# It is recommended to add the ``qodana.sarif.json`` to your ``.gitignore`` file.
#
# To use the image in GitHub Actions workflows, omit the ``--show-report`` and ``-p 8080:8080`` flags.
# Also remember that with GutHub Actions the the input device is not a TTY.
#
# == See also
#
# * Official Qodana docs -> https://www.jetbrains.com/help/qodana/getting-started.html
# * About the base image -> https://www.jetbrains.com/help/qodana/qodana-jvm-community-docker-readme.html
# * IntelliJ AsciiDoc Plugin docs -> https://intellij-asciidoc-plugin.ahus1.de/docs/users-guide/features/advanced/validation-cicd.html


FROM jetbrains/qodana-jvm-community:2023.3
LABEL maintainer="sebastian@sommerfeld.io"

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip=6.0-26+deb11u1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download AsciiDoc plugin for AsciiDoc checks
RUN mkdir -p /opt/idea/plugins/asciidoctor-intellij-plugin \
    && curl -L -o asciidoctor-intellij-plugin.zip https://github.com/asciidoctor/asciidoctor-intellij-plugin/releases/download/0.41.2/asciidoctor-intellij-plugin-0.41.2.zip \
    && unzip asciidoctor-intellij-plugin.zip -d /opt/idea/plugins \
    && rm asciidoctor-intellij-plugin.zip

# Download Grazie plugin for grammar checks -> https://plugins.jetbrains.com/plugin/12175-grazie/versions
RUN mkdir -p /opt/idea/plugins/grazie \
    && curl -L -o grazie.zip 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=257026' \
    && unzip grazie.zip -d /opt/idea/plugins \
    && rm grazie.zip

# Download Grazie Professional plugin for grammar checks -> https://plugins.jetbrains.com/plugin/16136-grazie-professional/versions
RUN mkdir -p /opt/idea/plugins/grazie-pro \
    && curl -L -o grazie-pro.zip 'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=260567' \
    && unzip grazie-pro.zip -d /opt/idea/plugins \
    && rm grazie-pro.zip
