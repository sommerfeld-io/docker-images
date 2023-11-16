# @file Dockerfile
# @brief Docker image that ships with the folderslint npm module.
#
# @description The link:https://hub.docker.com/r/sommerfeldio/folderslint[``sommerfeldio/folderslint``]
# image is a utility Docker image used in Github Actions workflows to validate the
# directory structure of a project. The image ships with
# link:https://www.npmjs.com/package/folderslint[folderslint].
#
# == About the tags and versions
#
# include::ROOT:partial$/docker-tag-strategy.adoc[]
#
# == How to use this image
# To use the image run the following command.
#
# ```
# docker run -it --rm --volume "$(pwd):$(pwd)" --workdir "$(pwd)" sommerfeldio/folderslint:latest
# ```
#
# === Use in a Github Actions workflow
#
# ```
# lint-folders:
#   runs-on: ubuntu-latest
#   steps:
#     - name: Checkout code
#       uses: actions/checkout@v3
#     - name: Run folderslint in container
#       run: docker run -i --rm --volume "$(pwd):$(pwd)" --workdir "$(pwd)" sommerfeldio/folderslint:latest
# ```


FROM node:21.2.0-alpine
LABEL maintainer="sebastian@sommerfeld.io"

RUN npm install --location=global folderslint@1.2.0

ENTRYPOINT [ "folderslint" ]
