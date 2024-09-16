#!/bin/bash

set -eux
set -o pipefail

HACK_DIR=$(dirname $0)

source ${HACK_DIR}/library.sh

KUBECONFIG=${HACK_DIR}/../admin.kubeconfig
EXTERNAL_HOSTNAME=https://kcp.cnoe.localtest.me:30007

install_go_tools

${IDPBUILDER} create --extra-ports 30007:30007

# This is based on kcp install instructions found here https://github.com/kcp-dev/helm-charts
kubectl apply -f ${HACK_DIR}/config/kcp

echo "Waiting for KCP installation. This can take a while..."
echo "In the meanwhile, you can login to argocd to watch installation using the idpbuilder info above."
kubectl wait --for=jsonpath='{.status.health.status}'=Healthy --timeout 10m -n argocd application/kcp

kubectl get secret kcp-front-proxy-cert -o=jsonpath='{.data.tls\.crt}' | base64 -d > ${HACK_DIR}/../ca.crt

kubectl --kubeconfig=${KUBECONFIG} config set-cluster base --server ${EXTERNAL_HOSTNAME} --certificate-authority=ca.crt
kubectl --kubeconfig=${KUBECONFIG} config set-cluster root --server ${EXTERNAL_HOSTNAME} --certificate-authority=ca.crt


kubectl apply -f ${HACK_DIR}/config/kcp-config
# Wait for client cert creation
kubectl wait --for=condition=Ready certificate.cert-manager.io/cluster-admin-client-cert

kubectl get secret cluster-admin-client-cert -o=jsonpath='{.data.tls\.crt}' | base64 -d > ${HACK_DIR}/../client.crt
kubectl get secret cluster-admin-client-cert -o=jsonpath='{.data.tls\.key}' | base64 -d > ${HACK_DIR}/../client.key
chmod 600 ${HACK_DIR}/../client.crt ${HACK_DIR}/../client.key

kubectl --kubeconfig=${KUBECONFIG} config set-credentials kcp-admin --client-certificate=${HACK_DIR}/../client.crt --client-key=${HACK_DIR}/../client.key
kubectl --kubeconfig=${KUBECONFIG} config set-context base --cluster=base --user=kcp-admin
kubectl --kubeconfig=${KUBECONFIG} config set-context root --cluster=root --user=kcp-admin
kubectl --kubeconfig=${KUBECONFIG} config use-context root
