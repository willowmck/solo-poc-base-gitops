# ee-fed demo2 environment details

## Gloo Edge Enterprise License
Before starting this demo, make sure that you have created a secret containing your Gloo Edge Enterprise license key. Gloo Edge expects a license to be created with a secret that is base64 encoded so let's do that.

First export your Gloo Enterprise license key as a variable
```
export GLOO_LICENSE_KEY=
```

Now run the following to create the kubernetes secret
```
kubectl create namespace gloo-system

BASE64_GLOO_LICENSE_KEY=$(echo -n $GLOO_LICENSE_KEY | base64 -w 0)

cat <<EOF | kubectl -n gloo-system create -f -
apiVersion: v1
data:
  license-key: "$BASE64_GLOO_LICENSE_KEY"
kind: Secret
metadata:
  labels:
    app: gloo
    app.kubernetes.io/instance: gloo-edge-ee-helm-customvalues
    gloo: license
  name: license
  namespace: gloo-system
type: Opaque
EOF
```

## Deploying demo2 app-of-app environment
To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo2/gloo-edge-ee-fed-demo2-aoa.yaml
```

This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-edge/ee-fed/demo2/active` directory:
- Gloo Edge Enterprise with Gloo Federation Enabled
- bookinfo-v1 application (black stars only)
- bookinfo-beta (all stars)
- httpbin application
- httpbin virtualservice

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.

### A few examples below

Deploy virtualservice exposing bookinfo-v1 app
```
kubectl apply -f app-of-apps/gloo-edge/ee-fed/demo2/non-active/1-bookinfo-vs.yaml
```

Deploy virtualservice demonstrating traffic splitting between bookinfo-v1 and bookinfo-beta app
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo2/non-active/2-bookinfo-multi-vs.yaml
```

Activate global rate-limit
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo2/non-active/global-ratelimit.yaml
```

Deploy keycloak v12.0.4
```
kubectl create -f app-of-apps/gloo-edge/ee-fed/demo2/non-active/keycloak-12-0-4.yaml
```