#! /bin/bash

environments=("development" "production")

for env in "${environments[@]}"; do
    export cluster_name=$env

    echo "Checking readiness for ${cluster_name} vcluster..."

    until kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm &> /dev/null; do
      echo "Waiting for ${cluster_name} vcluster secret to be ready..."
      sleep 10
    done

    echo "${cluster_name} vcluster is ready. Retrieving credentials..."
    export client_key=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "client-key" }}')
    export client_certificate=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "client-certificate" }}')
    export certificate_authority=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "certificate-authority" }}')

    kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${cluster_name}-vcluster-secret
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
    workload-class: "app-runtime"
    environment-name: "${cluster_name}"
type: Opaque
stringData:
  name: ${cluster_name}-vcluster
  server: https://${cluster_name}-vcluster.cnoe.localtest.me:443
  config: |
    {
      "tlsClientConfig": {
        "insecure": false,
        "caData": "${certificate_authority}",
        "certData": "${client_certificate}",
        "keyData": "${client_key}"
      }
    }
EOF
