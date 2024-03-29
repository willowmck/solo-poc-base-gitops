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
- [installing gloo-edge](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-edge)
  - [configuring gloo-fed](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-edge#configuring-gloo-fed)
  - [deploy hipstershop gloo-edge demo app](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/hipstershop/edge)
- [installing gloo-mesh](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-mesh)
  - [register cluster to gloo-mesh](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-mesh#register-current-cluster-istio-deployment-with-gloo-mesh-using-meshctl-useful-for-kind-or-local-deployments)
- [installing gloo-mesh-istio](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gm-istio)
  - [installing istio-addons](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gm-istio#install-istio-addons)
  - [deploy hipstershop istio demo app](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/hipstershop/istio)
- [installing gloo-portal](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-portal)
  - [deploying gloo-portal petstore demo](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-portal#optional-deploy-petstore-gloo-portal-demo-app)