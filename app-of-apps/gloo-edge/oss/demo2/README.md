# oss demo2 environment details

To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-edge/oss/demo2/gloo-edge-oss-demo2-aoa.yaml
```

This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-edge/oss/demo2/active` directory:
- Gloo Edge Open Source
- bookinfo-v1 application (black stars only)
- bookinfo-beta (all stars)
- httpbin application
- httpbin virtualservice

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.

### A few examples below

Deploy virtualservice exposing bookinfo-v1 app
```
kubectl apply -f app-of-apps/gloo-edge/oss/demo2/non-active/1-bookinfo-vs.yaml
```

Deploy virtualservice demonstrating traffic splitting between bookinfo-v1 and bookinfo-beta app
```
kubectl create -f app-of-apps/gloo-edge/oss/demo2/non-active/2-bookinfo-multi-vs.yaml
```