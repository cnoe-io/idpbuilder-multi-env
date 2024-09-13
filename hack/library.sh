## Location to install dependencies to
HACK_DIR=$(dirname $0)
ROOT_DIR=$(readlink -f $HACK_DIR/..)
LOCALBIN=${ROOT_DIR}/bin

## Tool Versions
IDPBUILDER_VERSION=8ab0e10

## Tool Binaries
export IDPBUILDER=${LOCALBIN}/idpbuilder-${IDPBUILDER_VERSION}

function go_install_tool() {
    if [ ! -f ${1} ]; then
        package=${2}@${3}
        echo "Downloading ${package}"
        GOBIN=${LOCALBIN} go install ${package}
        mv "$(echo "${1}" | sed "s/-${3}$//")" ${1}
    fi
}

function install_go_tools() {
    go_install_tool ${IDPBUILDER} github.com/cnoe-io/idpbuilder ${IDPBUILDER_VERSION}
}