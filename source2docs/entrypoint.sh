#!/bin/bash
# @file entrypoint.sh
# @brief Entrypoint for the Docker image. This file controls the creation of the Antora module and Asciidoc files.
#
# @description This script serves as the entrypoint for the
# xref:AUTO-GENERATED:src/main/docker/source2docs/Dockerfile.adoc[src/main/docker/source2docs/Dockerfile]
# which handles generating Asciidoc documentation based on inline documentation.
#
# The script scans the project for files matching ``.sh``, ``Dockerfile`` and ``docker-compose.yml``
# filenames and generates Asciidoc files from the source codes inline documentation.
#
# === Script Arguments
#
# The script does not accept any parameters.


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# constants
readonly ANTORA_YML="docs/antora.yml"
readonly ANTORA_MODULE_NAME="AUTO-GENERATED"
readonly ANTORA_MODULE="docs/modules/$ANTORA_MODULE_NAME"
export ANTORA_YML
export ANTORA_MODULE_NAME
export ANTORA_MODULE

readonly PATTERN_SH="*.sh"
readonly PATTERN_DOCKERFILE="Dockerfile"
readonly PATTERN_DOCKER_COMPOSE="docker-compose.yml"
readonly PATTERN_MAKEFILE="Makefile"
readonly PATTERN_VAGRANTFILE="Vagrantfile"
export PATTERN_SH
export PATTERN_DOCKERFILE
export PATTERN_DOCKER_COMPOSE
export PATTERN_MAKEFILE
export PATTERN_VAGRANTFILE

# global vars which are used and updated from functions
export SOURCE_CODE_FILE=""
export ADOC_FILE=""
export MD_FILE=""
export NAV_PARTIAL_PATH=""


# @description Check the current directory and validate that all needed subdirectories
# are present. It is expected that you run the Docker container from the root of your
# project and an Antora docs folder is present.
#
# @example
#    checkCurrentDirectory
#
# @exitcode 0 If successful
# @exitcode 1 If a mandatory subdirectory is missing
function checkCurrentDirectory() {
    echo "[INFO] Check current directory"

    declare -a MANDATORY_FOLDERS=(
        "docs"
        "docs/modules"
        "docs/modules/ROOT"
    )

    for mandatory in "${MANDATORY_FOLDERS[@]}"; do
        if [ ! -d "$mandatory" ]; then
            echo "[ERROR] Expected subdirectory '$mandatory' to exist"
            echo "[ERROR] exit" && exit 1
        fi
    done
}


# @description Clear and re-initialize the directory structure for the ``AUTO-GENERATED``
# Antora module.
#
# @example
#    initDirectoryTree
function initDirectoryTree() {
    echo "[INFO] Initialize directory tree"

    rm -rf "$ANTORA_MODULE"
    mkdir -p "$ANTORA_MODULE"
    mkdir -p "$ANTORA_MODULE/pages"
    mkdir -p "$ANTORA_MODULE/partials"
}


# @description Create the ``nav.adoc`` for the Antora module (the real one, not a partial).
# The ``nav.adoc`` is rather short because the real navigation takes place inside the
# ``AUTO-GENERATED`` modules startpage.
#
# @example
#    createModuleNav
function createModuleNav() {
    echo "[INFO] Create nav.adoc for the module $ANTORA_MODULE_NAME"
    echo "* xref:AUTO-GENERATED:index.adoc[]" > "$ANTORA_MODULE/nav.adoc"
}


# @description Write the ``index.adoc`` for the ``AUTO-GENERATED`` module based on the
# ``index-template.adoc``.
#
# @example
#    createModuleStartpage
function createModuleStartpage() {
    echo "[INFO] Create module startpage"
    cp "/source2docs/assets/index-template.adoc" "/project/$ANTORA_MODULE/pages/index.adoc"
}


# @description Add the module to the ``antora.yml`` file.
#
# @example
#    addModuleToAntoraYml
function addModuleToAntoraYml() {
    echo "[INFO] Add module to antora.yml"
    line="  - modules/$ANTORA_MODULE_NAME/nav.adoc"
    grep -qxF "$line" "$ANTORA_YML" || echo "$line" >> "$ANTORA_YML"
}


# @description Generate Asciidoc documentation files for the given filename pattern.
# Find all files that match the pattern and generate adoc pages with information from
# the source code files inline docs. Inline docs must comply to
# link:https://github.com/reconquest/shdoc[shdoc].
#
# @example
#    generateDocsForPattern '*.sh' 'bash-docs'
#
# @arg $1 string File name pattern which is passed to ``find``
#
# @exitcode 0 If successful
# @exitcode 1 If file name pattern is missing (e.g. ``*.sh``)
function generateDocsForPattern() {
    if [ -z "$1" ]; then
        echo -e "$LOG_ERROR Param missing: File name pattern"
        echo -e "$LOG_ERROR exit" && exit 1
    fi

    initNavPartial "$1"

    echo "[INFO] Find all $1 files"
    find "$(pwd)" -type f -name "$1" -exec bash -c 'createDocsFromSourceCodeFile "$0"' {} \;
}


# @description Initialize the ``docs/modules/AUTO-GENERATED/partials/nav-<SOURCE_TYPE>.adoc``
# file which contains the navigation for the respective source code type and is included
# from the ``docs/modules/AUTO-GENERATED/pages/index.adoc``.
#
# The adoc-partials are included from the ``AUTO-GENERATED`` modules index.adoc
# which is based on the ``index-template.adoc`` from this repository.
#
# @example
#    initNavPartial '*.sh' 'bash-docs'
#
# @arg $1 string File name pattern which is passed to ``find``
#
# @exitcode 0 If successful
# @exitcode 1 If file name pattern is missing (e.g. ``*.sh``)
function initNavPartial() {
    if [ -z "$1" ]; then
        echo -e "$LOG_ERROR Param missing: File name pattern"
        echo -e "$LOG_ERROR exit" && exit 1
    fi

    case "$1" in
        "$PATTERN_SH")
            NAV_PARTIAL_PATH="$ANTORA_MODULE/partials/nav-bash.adoc"
        ;;
        "$PATTERN_DOCKERFILE")
            NAV_PARTIAL_PATH="$ANTORA_MODULE/partials/nav-dockerfile.adoc"
        ;;
        "$PATTERN_DOCKER_COMPOSE")
            NAV_PARTIAL_PATH="$ANTORA_MODULE/partials/nav-docker-compose.adoc"
        ;;
        "$PATTERN_MAKEFILE")
            NAV_PARTIAL_PATH="$ANTORA_MODULE/partials/nav-makefile.adoc"
        ;;
        "$PATTERN_VAGRANTFILE")
            NAV_PARTIAL_PATH="$ANTORA_MODULE/partials/nav-vagrantfile.adoc"
        ;;
    esac

    echo "[INFO] Create navigation partial $NAV_PARTIAL_PATH"
    touch "$NAV_PARTIAL_PATH"
}


# @description Iterate files based on the given filename pattern and trigger
# generating Asciidoc pages based on the source codes inline docs. Building a
# navigation is triggered as well.
#
# @example
#    createDocsFromSourceCodeFile '*.sh'
#
# @arg $1 string Path to source code file
#
# @exitcode 0 If successful
# @exitcode 1 If path to source code file is missing
function createDocsFromSourceCodeFile() {
    if [ -z "$1" ]; then
        echo -e "$LOG_ERROR Param missing: Path to source code file"
        echo -e "$LOG_ERROR exit" && exit 1
    fi

    echo "[INFO]   Create docs for $1"
    translateSourceCodeFilePathToAdocPath "$1"
    createAdocFromSourceCodeFile
    createLinkInNavPartial
}
export -f createDocsFromSourceCodeFile


# @description Translate the path and filename of a source code file
# into a path and filename that will be written into the ``AUTO-GENERATED``
# module.
#
# @example
#    translateSourceCodeFilePathToAdocPath /path/to/source/file.sh
#
# @arg $1 string Path to source code file
#
# @exitcode 0 If successful
# @exitcode 1 If path to source code file is missing
function translateSourceCodeFilePathToAdocPath() {
    if [ -z "$1" ]; then
        echo -e "$LOG_ERROR Param missing: Path to source code file"
        echo -e "$LOG_ERROR exit" && exit 1
    fi

    echo "[INFO]     Translate source file path to adoc path"

    SOURCE_CODE_FILE="${1#"/project/"}" # make path relative (from project root)

    old="."; new="-"
    docs_path="${SOURCE_CODE_FILE//$old/$new}" # replace all occurences of $old

    ADOC_FILE="$docs_path.adoc"
    MD_FILE="$docs_path.md"
}
export -f translateSourceCodeFilePathToAdocPath


# @description Create Asciidoc file for given source code file. Instead
# of params, this script relies on global vars which where set by
# ``translateSourceCodeFilePathToAdocPath``.
#
# @example
#    createAdocFromSourceCodeFile
#
# @exitcode 0 If successful
function createAdocFromSourceCodeFile() {
    target_folder="$ANTORA_MODULE/pages/$ADOC_FILE"
    target_folder="${target_folder%/*}"

    echo "[INFO]     Create folder $target_folder"
    mkdir -p "$target_folder"

    echo "[INFO]     Create intermediate markdown file $ANTORA_MODULE/pages/$MD_FILE"
    shdoc < "$SOURCE_CODE_FILE" > "$ANTORA_MODULE/pages/$MD_FILE"

    echo "[INFO]     Create adoc file $ANTORA_MODULE/pages/$ADOC_FILE from markdown"
    kramdoc -o "$ANTORA_MODULE/pages/$ADOC_FILE" "$ANTORA_MODULE/pages/$MD_FILE"

    echo "[INFO]     Remove intermediate markdown file $ANTORA_MODULE/pages/$MD_FILE"
    rm "$ANTORA_MODULE/pages/$MD_FILE"

    echo "[INFO]     Fix index-navigation in adoc file"
    old="<<"; new="<<_"
    sed -i "s/$old/$new/g" "$ANTORA_MODULE/pages/$ADOC_FILE"
}
export -f createAdocFromSourceCodeFile


# @description Add a link to an adoc file to the navigation partial. Instead
# of params, this script relies on global vars which where set by
# ``initNavPartial``.
#
# @example
#    createLinkInNavPartial
#
# @exitcode 0 If successful
function createLinkInNavPartial() {
    echo "[INFO]     Write link to $ADOC_FILE into $NAV_PARTIAL_PATH"
    echo "* xref:${ANTORA_MODULE_NAME}:${ADOC_FILE}[${SOURCE_CODE_FILE}]" >> "$NAV_PARTIAL_PATH"
}
export -f createLinkInNavPartial


echo "[INFO] ======================================================================"
#echo "[INFO] Version $(shdoc --version)"
echo "[INFO] whoami = $(whoami)"
echo "[INFO] Start source2docs"
echo "[INFO] ======================================================================"

checkCurrentDirectory
initDirectoryTree
createModuleNav
createModuleStartpage
addModuleToAntoraYml
generateDocsForPattern "$PATTERN_SH"
generateDocsForPattern "$PATTERN_DOCKERFILE"
generateDocsForPattern "$PATTERN_DOCKER_COMPOSE"
generateDocsForPattern "$PATTERN_MAKEFILE"
generateDocsForPattern "$PATTERN_VAGRANTFILE"
