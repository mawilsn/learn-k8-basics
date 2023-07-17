#!/bin/bash

# Start minikubectl
minikube start
# kubernetes deployment
if kubectl get deployment "$KD" >/dev/null 2>&1; then
    echo "Deployment $KD already exists."
    kubectl proxy
else
    echo "Deployment $KD does not exist. Creating it..."
    kubectl create deployment "$KD" --image=gcr.io/google-samples/kubernetes-bootcamp:v1
    kubectl proxy
fi

# podname
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
echo Name of the Pod: $POD_NAME

# curl pod through api
curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME/