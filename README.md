# IDP Builder Multi-Environment

Multi-environment emulation of CNOE using idpbuilder + vcluster

## Running (using Go)

If you have Go installed, you can run the following:

```bash
./hack/setup.sh
```

## Running (using idpbuilder binary)

Download idpbuilder and execute the following:

```bash
idpbuilder -p hack/config/cnoe-packages/vcluster -p hack/config/cnoe-packages/deploy-apps
```
