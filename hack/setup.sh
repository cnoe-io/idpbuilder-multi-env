#!/bin/bash

set -eux
set -o pipefail

HACK_DIR=$(dirname $0)

source ${HACK_DIR}/library.sh

install_go_tools

${IDPBUILDER} create \
    -p ${HACK_DIR}/config/vcluster-generator \
    -p ${HACK_DIR}/config/deploy-apps
