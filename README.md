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

## Useage

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
curl -v wget http://127.0.0.1:8080/<bucket>/<object>
```

