# Keptn Podtatohead

This is another sample workload using kubernetes' podtatohead examples which leverages Keptn.

## Installing Keptn

Keptn needs to be installe before this sample can be used. That can be done with the following command, run from the root of this repository:

```bash
kubectl apply -f config/keptn
```

## Installing Workload

Installing this demo workload can be done by installing it as an idpbuilder package:

```bash
idpbuilder create -p .
```