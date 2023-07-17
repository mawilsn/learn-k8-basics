# learn-k8-basics
This is going over the basics of kubernetes found on their website as of 2023-07-16


# Install Tools

- editor VSCode
- OS: Pop!_OS 22.04 LTS
- kubectl: 
  - https://kubernetes.io/docs/tasks/tools/
  - for linux: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
  - By default, kubectl configuration is located at ~/.kube/config

- Minikube
  - https://minikube.sigs.k8s.io/docs/start/
- bash: GNU bash, version 5.1.16(1)-release (x86_64-pc-linux-gnu)


# Using Minikube to create a cluster
https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-intro/
## Objectives
- know how to explain kubernetes
- what is minikube
- Start a kluster


## Kubernetes clusters
- Kubernetes coordinates a highly available cluster of computers that are connected to work as a single unit
  - Something to chew one: what does *highly avaialble cluster mean?*
- K allows me to deploy to a cluster, not an indvidual machine.
- Applications need to be decoupled from individual hosts.
- Apps need to be containerized.


### Kubernetes cluster consists of two types of resources
- control plane: Coordinates the clust
  - scheduling
  - maintaining app desired state
  - scaling app
  - rolling out updates
- Nodes: are workes that  run apps.
  - is a VM or physical computer that serves as a worker machine in a k cluster
  - A node has a Kublet which is an agent for managing the node and communicating with kuvbernetes control plane.
  - Showld have tools for handling container ops. Suchas docker or containerd
  - should always have at least 3 nodes. f three nodes because if one node goes down, both an etcd member and a control plane instance are lost, and redundancy is compromised. You can mitigate this risk by adding more control plane nodes.

- When you deploy to kubernetes, you tell the control plane to start the app container.
- The control plane scehdueld the containers to run on the cluster's nodes.
- The nodes communicate with the control plane  using kubernetes api.

Control Planes manage the cluster and the nodes that are used to host the running applications.

![Cluster](/imgs/module_01_cluster.svg "Cluster Diagram")


# Using kubectl to create a deployment.
## Objectives
- learn about application deployments
- deploy your first app on kubernetes with kubectl

## kubernetes deploytments
![Cluster](/imgs/module_02_first_app.svg "Deploying your first app on Kubernetes")

- once a running kubernetes cluster, you can deploy your app.
- Kubernetes deployment (KD) instructs how to create and update your application.
- KD will continously monitor your instances on another node in the cluster.


### Kubectl basics
- `kubectl do something`
  - `--help` after subcommand
    - `kubectl get nodes --help`
  - `kubectl version`
  - `kubectl get nodes` - views the nodes
  - `kubectl create deployment *name* --image=*image*`
  - `kubectl get deployments`
  
### deploy app

Kubernetes deployment below, we give it a name and an image location
```bash
$ kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1

```

List the deployemetns
```bash
$ kubectl get deployments

NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
kubernetes-bootcamp   0/1     1            0           6s
```

### view the app

Pods running inside kubernetes are on private, isolated network. By default visable to other pods and services in the deployment within the same cluster, not outside the network.

- kubectl can create a proxy that can forward communicaion into the cluster wide, private nework.
- Proxy can be terminated by ctrl+c
- you will need a second terminal
```bash
  $ kubectl proxy
```
- cul to see the version using the proxy endpoint

```bash
$ curl http://localhost:8001/version
{
  "major": "1",
  "minor": "26",
  "gitVersion": "v1.26.3",
  "gitCommit": "9e644106593f3f4aa98f8a84b23db5fa378900bd",
  "gitTreeState": "clean",
  "buildDate": "2023-03-15T13:33:12Z",
  "goVersion": "go1.19.7",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```

- the api server will automatically create an endpoint for each pod based on the pod name that is also accessible throught e proxy
- first we need to get the pod name

```bash
$ export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
$ echo Name of the Pod: $POD_NAME

```
you can access the pod through the proxied api
```bash
curl http://localhost:8001/api/v1/namespaces/default/pods/{$POD_NAME}/

```
## Deploying your first insance
- kubectl cli for managing deployment
- kubectl uses the kubernetes api
- when you create a deployment, must specify the container image your application and number replicas that you want to run.
# CMD
- `lsb_release -a` find version on linux ubuntu
