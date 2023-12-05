# @file Makefile
# @brief Lint this repository and build all Docker images.
#
# @description This Makefile helps maintain code quality by using linters consistent
# with our GitHub Actions, and it ensures the Dockerfiles are properly structured and
# meet standards using Hadolint before creating Docker images from the repository.
#
# == How to use this Makefile
#
# The default target, which is triggered when simply using ``make`` build all Docker
# images from this repository.
#
# === ``make test``
#
# This target runs the same linters as the GitHub Actions workflow. By applying these
# linters, it ensures the code in the repository meets quality standards and follows
# best practices.
#
# === ``make build``
#
# The target handles the process of building Docker images from the repository. Before
# building the Docker images, the Makefile verifies the Dockerfiles using Hadolint.
# Hadolint is a linter specifically designed for Dockerfiles. It checks for adherence
# to best practices and potential issues in the Dockerfile syntax and structure.


.DEFAULT_GOAL := all
.PHONY: test clean all


define build_image
	docker run --rm -i hadolint/hadolint:latest < "$(1)/Dockerfile"
	docker build -t "local/$(1):dev" $(1)
endef


all: test devcontainer-go devcontainer-ubuntu folderslint ftp-client jq source2docs

test:
	docker run --rm --volume "$(shell pwd):/data" cytopia/checkmake:latest Makefile
	docker run --rm  $$(tty -s && echo "-it" || echo) --volume $(shell pwd):/data cytopia/yamllint:latest .
	docker run --rm -i --volume "$(shell pwd):$(shell pwd)" --workdir "$(shell pwd)" sommerfeldio/folderslint:latest folderslint
	docker run --rm -i --volume "$(shell pwd):/data" --workdir "/data" lslintorg/ls-lint:1.11.2

devcontainer-go: test
	$(call build_image,"$@")

devcontainer-ubuntu: test
	$(call build_image,"$@")

folderslint: test
	$(call build_image,"$@")

ftp-client: test
	$(call build_image,"$@")

jq: test
	$(call build_image,"$@")

source2docs: test
	$(call build_image,"$@")
