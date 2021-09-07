# gloo-edge

## Prerequisites
- Kubernetes clusters up and authenticated to kubectl
- argocd

## kubectl contexts
Since we will potentially be using multiple clusters/contexts, it is useful to rename your contexts for a better experience
```
kubectl config get-contexts
kubectl config rename-contexts <current_name> <new_name>
export CONTEXT=<new_name>
```

## Install Argo CLI
On Mac:
```
brew install argo
```

## installing argo server
Navigate to the `argo-workflows` directory
```
cd argo-workflows
```

Deploy the `argo-workflows.yaml` app
```
kubectl apply -f 1-argo-workflows.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../wait-for-rollout.sh deployment argo-workflows-helm-server argo 10
```

Output should look similar to below:
```
$ ../wait-for-rollout.sh deployment argo-workflows-helm-server argo 10
Waiting 10 seconds for deployment argo-workflows-helm-server to come up.
Error from server (NotFound): deployments.apps "argo-workflows-helm-server" not found
Waiting 20 seconds for deployment argo-workflows-helm-server to come up.
Waiting for deployment "argo-workflows-helm-server" rollout to finish: 0 of 1 updated replicas are available...
deployment "argo-workflows-helm-server" successfully rolled out
Waiting 30 seconds for deployment argo-workflows-helm-server to come up.
deployment "argo-workflows-helm-server" successfully rolled out
```

### Open the Dashboard
```
argo server
```
This will start a server on port 2746 which you can view at https://localhost:2746.

## Next Steps - Deploy apps using argo workflows
[Follow this Tutorial Here](./apps/README.md)