# @file Dockerfile
# @brief Docker image to use ``terraform`` from a container. The image contains other software which is needed by other Terraform provideres as well.
#
# @description Run ``terraform`` commands without installing Terraform onto any machine.
# The only dependency is link:https://www.docker.com[Docker]. The image ships with some
# addtional software like the link:https://bitwarden.com/help/cli[Bitwarden CLI] which
# is needed for the link:https://registry.terraform.io/providers/maxlaverse/bitwarden/latest/docs[Terraform Bitwarden Provider]
# to work.
#
# The image is published to DockerHub as link:https://hub.docker.com/r/sommerfeldio/terraform[``sommerfeldio/terraform``]
#
# This project is used for my
# link:https://github.com/sebastian-sommerfeld-io/configs/actions/workflows/configure-github.yml[Global: Apply Github Configuration]
# pipeline. The pipeline ensures a consistent Github configuration and all configuration
# for all repositories.
#
# == About the tags and versions
#
# include::ROOT:partial$/docker-tag-strategy.adoc[]
#
# == How to use this image
#
# Use this command to run the image as a non-root user (pass the current user of the
# host into the container). This is tested on Ubuntu 22.04. This example needs three
# environment variables ``TV_VAR_bw_*`` for the Bitwarden CLI (which is used by the
# link:https://registry.terraform.io/providers/maxlaverse/bitwarden/latest/docs[Terraform Bitwarden Provider])
# to work. The ``GITHUB_TOKEN`` environment variable is needed for the
# link:https://registry.terraform.io/providers/integrations/github/latest/docs[Terraform Github Provider].
# Adjust the environment variables according to your needs.
#
# [source, bash]
#
# ....
# BW_CLIENT_ID="bitwarden-data"
# BW_CLIENT_SECRET="bitwarden-data"
# BW_MASTER_PASS="bitwarden-data"
#
# docker run --rm \
#     --volume /etc/passwd:/etc/passwd:ro \
#     --volume /etc/group:/etc/group:ro \
#     --user "$(id -u):$(id -g)" \
#     --volume /etc/timezone:/etc/timezone:ro \
#     --volume /etc/localtime:/etc/localtime:ro \
#     --volume "$(pwd):$(pwd)" \
#     --workdir "$(pwd)" \
#     --env "GITHUB_TOKEN=$TOKEN" \
#     --env "TF_VAR_bw_client_id=$BW_CLIENT_ID" \
#     --env "TF_VAR_bw_client_secret=$BW_CLIENT_SECRET" \
#     --env "TF_VAR_bw_password=$BW_MASTER_PASS" \
#     sommerfeldio/terraform:latest apply -auto-approve
# ....
#
# CAUTION: Keep in mind that storing passwords in variables like this is not a
# recommended way to handle your secrets.


FROM hashicorp/terraform:1.5.1
LABEL maintainer="sebastian@sommerfeld.io"

# Install basics
ARG CURL_VERSION="8.4.0-r0"
RUN apk update \
    && apk --no-cache add curl=${CURL_VERSION} \
    && apk --no-cache add libcurl=${CURL_VERSION} \
    && apk --no-cache add unzip=6.0-r14

# Install Bitwarden CLI + dependencies
ARG BW_VERSION="2022.11.0"
RUN apk --no-cache add libc6-compat=1.2.4-r2 \
    && apk --no-cache add gcompat=1.1.0-r1 \
    && apk --no-cache add libgcc=12.2.1_git20220924-r10 \
    && apk --no-cache add libstdc++=12.2.1_git20220924-r10 \
    && rm -rf /var/cache/apk/* \
    && curl -L https://github.com/bitwarden/clients/releases/download/cli-v${BW_VERSION}/bw-linux-${BW_VERSION}.zip -o bw.zip \
    && unzip bw.zip \
    && chmod +rx bw \
    && rm bw.zip \
    && mv bw /usr/local/bin
