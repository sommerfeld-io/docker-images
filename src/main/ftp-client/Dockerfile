# @file Dockerfile
# @brief Docker image with ncftp for uploads and downloads via FTP.
#
# @description The link:https://hub.docker.com/r/sommerfeldio/ftp-client[``sommerfeldio/ftp-client``]
# image ships with NCFTP and uses link:https://www.ncftp.com/ncftp/doc/ncftpput.html[ncftpput]
# for FTP uploads and downloads.
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
# FTP_HOST="ftp-host.example.com"
# FTP_USER="the_username"
# FTP_PASS="the_password"
#
# echo "Upload via FTP"
# docker run -i --rm \
#     --volume "$(pwd):$(pwd)" \
#     --workdir "$(pwd)" \
#     sommerfeldio/ftp-client:latest ncftpput -R -v -u "$FTP_USER" -p "$FTP_PASS" "$FTP_HOST" / *
# ```
#
# CAUTION: Keep in mind that storing passwords in variables like this is not a
# recommended way to handle your secrets.
#
# == See also
#
# For Docker image sources, see https://github.com/sommerfeld-io/docker-images/tree/main/src/main.



FROM ubuntu:24.04
LABEL maintainer="sebastian@sommerfeld.io"

RUN apt-get update \
    && apt-get install -y --no-install-recommends ncftp=2:3.2.6-1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
