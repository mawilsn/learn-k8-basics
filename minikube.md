# Minikube


## Install Minikube

1. Iinstall stable release:

```bash

$ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
$ sudo dpkg -i minikube_latest_amd64.deb

```
2. Start Cluster

``` bash
$ minikube start

```

3. Interact with your cluster
   1. Already installed: `kubectl get po -A`
   2. or allow minikub to download the appropriate version of kubectl `minikube kubectl -- get po -A`

You can alsows make your life easier (I don't know what this is yet) and add this to your shell config
```bash
$ alias kubectl="minikube kubectl --"

```
also there is a dashboard

```
$ minikube dashboard

```

### Deploying some sample applications with minikube
#### sample deployment

1. create a sample deployment exposed on 8080:
```bash
$ kubectl create deployment hello-minikube --image=kicbase/echo-server:1.0
$ kubectl expose deployment hello-minikube --type=NodePort --port=8080

```
2. It will take moment. The deployment will show up when you run

```bash
$ kubectl get service hello-minikube

```
3. the easiet way to access this sercies is to let minikuvbe launch a webbrowser for you:

```bash
$ minikube services hello-minikube
```
alt use kubectl to forward the port:
```
$ kubectl port-forward service/hello-minikube 7080:8080
```
app will be available on *http://localhost:7080/*

#### LoadBalancer

1. To access a LoadBalancer deployment, use the “minikube tunnel” command. Here is an example deployment:

```bash
$ kubectl create deployment balanced --image=kicbase/echo-server:1.0
$ kubectl expose deployment balanced --type=LoadBalancer --port=8080

```

2. In another window, start the tunnel to create a routable IP for the ‘balanced’ deployment:

```bash
$ minikube tunnel
```
3. To find the routable IP, run this command and examine the EXTERNAL-IP column:

```bash
$ kubectl get services balanced
```
Your deployment is now available at <EXTERNAL-IP>:8080



#### ingress


1. Enable ingress addon:

``` bash
$ minikube addons enable ingress
```
The following example creates simple echo-server services and an Ingress object to route to these services.

```yaml
kind: Pod
apiVersion: v1
metadata:
  name: foo-app
  labels:
    app: foo
spec:
  containers:
    - name: foo-app
      image: 'kicbase/echo-server:1.0'
---
kind: Service
apiVersion: v1
metadata:
  name: foo-service
spec:
  selector:
    app: foo
  ports:
    - port: 8080
---
kind: Pod
apiVersion: v1
metadata:
  name: bar-app
  labels:
    app: bar
spec:
  containers:
    - name: bar-app
      image: 'kicbase/echo-server:1.0'
---
kind: Service
apiVersion: v1
metadata:
  name: bar-service
spec:
  selector:
    app: bar
  ports:
    - port: 8080
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /foo
            backend:
              service:
                name: foo-service
                port:
                  number: 8080
          - pathType: Prefix
            path: /bar
            backend:
              service:
                name: bar-service
                port:
                  number: 8080
---
```
2. Apply the contents

```bash
$ kubectl apply -f https://storage.googleapis.com/minikube-site-examples/ingress-example.yaml
```
Wait for ingress address
```bash
$ kubectl get ingress
NAME              CLASS   HOSTS   ADDRESS          PORTS   AGE
example-ingress   nginx   *       <your_ip_here>   80      5m45s
```
Note for Docker Desktop Users:
To get ingress to work you’ll need to open a new terminal window and run minikube tunnel and in the following step use 127.0.0.1 in place of <ip_from_above>.

3. Now verify that the ingress works

```bash
$ curl <ip_from_above>/foo
Request served by foo-app

```
```bash
$ curl <ip_from_above>/bar
Request served by bar-app
```
...

### manage minkube cluser

Pause Kubernetes without impacting deployed applications:

```bash
minikube pause

```
Unpause a paused instance:

```bash
minikube unpause
```
Halt the cluster:

```bash
minikube stop
```
Change the default memory limit (requires a restart):
```bash
minikube config set memory 9001
```
Browse the catalog of easily installed Kubernetes services:
```bash
minikube addons list
```
Create a second cluster running an older Kubernetes release:
```bash
minikube start -p aged --kubernetes-version=v1.16.1
```
Delete all of the minikube clusters:
```bash
minikube delete --all
```