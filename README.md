# gcsproxy
Reverse proxy for Google Cloud Storage.

## Description
This is a reverse proxy for Google Cloud Storage for performing limited disclosure (IP address restriction etc...). Gets the URL of the GCS object through its internal API. Therefore, it is possible to make GCS objects private and deliver limited content.

```
 +---------------------------------------+
 |                Nginx                  |
 |    access controll (basic auth/ip)    |
 +-----+---------------------------------+
       |
-----------------------------------------+
       |
       |
+------v-----+          +---------------+
|            |          |               |
|  gcsproxy  | +------> | Google Cloud  |
|            |          |    Storage    |
+------------+          +---------------+
```

## Usage

```
Usage of gcsproxy:
  -p string
    	Listen port (default ":8080")
  -c string
    	The path to the keyfile. If not present, client will use your default application credentials.
  -v	Show access log

```

```bash
make
# command line
bin/gcsproxy -c /etc/gcs.json -v
# docker run
docker run  -ti -p 8080:8080 -v /etc/gcs.json:/etc/gcs.json gcsproxy /usr/bin/gcsproxy -c /etc/gcs.json -v
# test
curl -v http://127.0.0.1:8080/<bucket>/<object>
```

## Deploy on Kubernetes

* Get a GCS key and create a configmap

```bash
kubectl create configmap gcs-key --from-file=gcs.json
```

* Create nginx config as a configmap

```bash
kubectl create configmap nginx-conf --from-file=deploy/kubernetes/nginx-gcs.conf

```

* Create nginx cache + gcsproxy deployment

```bash
kubectl apply -f deploy/kubernetes/nginx.yaml
```

* Check if the pod is running and service is created

```console
# kubectl get pod
NAME                                                        READY   STATUS    RESTARTS   AGE
gcs-cache-6f6947b8cf-fdkf5                                  2/2     Running   0          9m31s

# kubectl get svc
NAME                               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
cache                              ClusterIP   10.102.88.144   <none>        80/TCP    9m10s
```

* Test it

Use the cache's cluster IP 10.102.88.144:

```console
# kubectl run --rm -i -t ephemeral --image=busybox -- /bin/sh -l
If you don't see a command prompt, try pressing enter.
/ # wget 10.102.88.144/xxxxxxxx > /dev/null
Connecting to 10.102.88.144 (10.102.88.144:80)
xxxxxx    100% |**********************************************************************************************************************************************|  979M  0:00:00 ETA
```