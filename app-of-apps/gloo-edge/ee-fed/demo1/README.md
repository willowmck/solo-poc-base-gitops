# ee-fed demo1 environment details

To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo1/gloo-edge-ee-fed-demo1-aoa.yaml
```

This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-edge/ee-fed/demo1/active` directory:
- Gloo Edge Enterprise with Gloo Federation Enabled
- httpbin application

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.

### A few examples below

Activate global rate-limit
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo1/non-active/global-ratelimit.yaml
```

Deploy virtualservice exposing httpbin app using Gloo Edge
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo1/non-active/httpbin-vs-default.yaml
```

Deploy keycloak v12.0.4
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo1/non-active/keycloak-12-0-4.yaml
```

