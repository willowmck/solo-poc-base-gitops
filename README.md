# solo-poc-base-gitops
 argocd app collection of base components for solo POCs
 
# Prerequisites
- Kubernetes clusters up and authenticated to kubectl
- argocd

## kubectl contexts
Since we will potentially be using multiple clusters/contexts, it is useful to rename your contexts for a better experience
```
kubectl config get-contexts
kubectl config rename-contexts <current_name> <new_name>
export CONTEXT=<new_name>
```

## Table of Contents
- [installing argocd](https://github.com/ably77/solo-poc-base-gitops/tree/main/argocd)
- [installing gloo-edge](https://github.com/ably77/solo-poc-base-gitops#installing-gloo-edge)
- [configuring gloo-fed](https://github.com/ably77/solo-poc-base-gitops#gloo-fed)
- [installing gloo-mesh](https://github.com/ably77/solo-poc-base-gitops#installing-gloo-mesh)
- [installing gloo-mesh-istio](https://github.com/ably77/solo-poc-base-gitops#installing-gloo-mesh-istio)
- [configuring istio-addons](https://github.com/ably77/solo-poc-base-gitops#install-istio-addons)
- [installing gloo-portal](https://github.com/ably77/solo-poc-base-gitops#installing-gloo-portal)