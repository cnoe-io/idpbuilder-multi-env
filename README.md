# IDP Builder Multi-Environment

Multi-environment emulation of CNOE using idpbuilder + vcluster

# Running

## Step 1: Deploy CNOE + vcluster environments

### Option 1: Using Go

If you have Go installed, you can run the following:

```bash
./hack/setup.sh
```

### Option 2: Using idpbuilder binary

Download idpbuilder and execute the following:

```bash
idpbuilder -p hack/config/vcluster-generator -p hack/config/deploy-apps
```

## Step 2: Enroll vclusters in ArgoCD

For each cluster created (development, staging, production), do:

```bash
export cluster_name="development"
export client_key=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "client-key" }}')
export client_certificate=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "client-certificate" }}')
export certificate_authority=$(kubectl get secret -n ${cluster_name}-vcluster vc-${cluster_name}-vcluster-helm --template='{{index .data "certificate-authority" }}')
```

```bash
cat <<EOF > cluster-secret.yaml
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
```

```bash
kubectl apply -f cluster-secret.yaml
```
