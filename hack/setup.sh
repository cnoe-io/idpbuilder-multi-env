#!/bin/bash

set -eux
set -o pipefail

HACK_DIR=$(dirname $0)

source ${HACK_DIR}/library.sh

install_go_tools

${IDPBUILDER} create

kubectl apply -f ${HACK_DIR}/config/vcluster
