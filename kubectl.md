## Kubectl for Debian Based
1. update and get the kubernetes
   
   ```bash
   $ sudo apt-get update
   $ sudo apt-get install -y ca-certificates curl

   ```

2. Download the goodl cloud public sigining key. (not for sure why)

```bash
$ curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

```

3. add Kubernetes to the `apt` repo:

```
$ echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

```

4. update apt and install  with new repo and install kubectl:

```
$ sudo apt-get update
$ sudo apt-get install -y kubectl
```

5. Verify the instalation
   "In order for kubectl to find and access a Kubernetes cluster, it needs a kubeconfig file, which is created automatically when you create a cluster using kube-up.sh or successfully deploy a Minikube cluster. By default, kubectl configuration is located at ~/.kube/config.

Check that kubectl is properly configured by getting the cluster state:"

``` bash
$ kubectl cluster-info
```

"If you see a URL response, kubectl is correctly configured to access your cluster.

If you see a message similar to the following, kubectl is not configured correctly or is not able to connect to a Kubernetes cluster."
```bash
$ The connection to the server <server-name:port> was refused - did you specify the right host or port?
```

When I installed this, I got this message. **To Fix it** you will need to install a tool like minukube

