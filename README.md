# IDP Builder Multi-Environment

Multi-environment emulation of CNOE using idpbuilder + vcluster

# Running

## Step 1: Deploy CNOE + vcluster environments

### Option 1: Using Go

If you have Go installed, you can simply run the following:

```bash
./hack/setup.sh
```

### Option 2: Using idpbuilder binary

If you prefer not to install Go SDK you can download the [idpbuilder binary](https://github.com/cnoe-io/idpbuilder/releases/tag/v0.8.0-nightly.20240918) and execute the following:

```bash
idpbuilder -p config/cnoe-packages
./hack/add-vclusters.sh
```

## Step 2: Deploy some workloads!

You now have a CNOE reference stack which includes two vclusters named "production" and "staging" that are both added as clusters to the CNOE provided ArgoCD. It is now up to you to deploy any multi-cluster workloads you wish to experiment with, or deploy one of the sample worloads included under `config/workloads` (more information below).

# Connect to ArgoCD

See the output from Step 1 to see how to connect to argocd. Typically, you can browse to (https://argocd.cnoe.localtest.me:8443/) and login with the credentials shown by running `./bin/idpbuilder-8ab0e10 get secrets -p argocd`.

# Deploy sample workload

The easiest way to deploy a sample workload is to run `idpbuilder create` with the workload added as an extra package. Assuming you used the Go-based setup script, here is an example:

```bash
./bin/idpbuilder-8ab0e10 create -p config/cnoe-packages -p config/workloads/simple-podtatohead
```
