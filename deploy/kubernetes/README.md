# Deploy GCS Proxy
## Create GCS JSON key configmap

```bash
kubectl create configmap gcs-key --from-file=/<path>/gcs.json
```

## Create SVC and Deployment
```bash
kubectl apply -f proxy.yaml
```

## Watch SVC and Pod
```bash
kubectl get pod,svc
```