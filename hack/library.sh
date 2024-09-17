## Location to install dependencies to
HACK_DIR=$(dirname $0)
ROOT_DIR=$(readlink -f $HACK_DIR/..)
LOCALBIN=${ROOT_DIR}/bin

## Tool Versions
IDPBUILDER_VERSION=8ab0e10
KUBECTL_VERSION=v1.31.1
VCLUSTER_VERSION=v0.20.0

## Tool Binaries
export IDPBUILDER=${LOCALBIN}/idpbuilder-${IDPBUILDER_VERSION}
export KUBECTL=${LOCALBIN}/kubectl-${KUBECTL_VERSION}
export VCLUSTER=${LOCALBIN}/vcluster-${VCLUSTER_VERSION}

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

    # Kubectl
    if [ ! -x ${KUBECTL} ]; then
        curl -L "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/$(go env GOARCH)/kubectl" -o ${KUBECTL}
        chmod +x ${KUBECTL}
    fi

    # Vcluster
    if [ ! -x ${VCLUSTER} ]; then
        curl -L "https://github.com/loft-sh/vcluster/releases/download/${VCLUSTER_VERSION}/vcluster-$(go env GOOS)-$(go env GOARCH)" -o ${VCLUSTER}
        chmod +x ${VCLUSTER}
    fi
}