# oss demo1 environment details

To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-edge/oss/demo1/gloo-edge-oss-demo1-aoa.yaml
```

This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-edge/oss/demo1/active` directory:
- Gloo Edge Open Source
- httpbin application

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.

### An example below
Deploy virtualservice exposing httpbin app using Gloo Edge
```
kubectl create -f app-of-apps/gloo-edge/oss/demo1/non-active/httpbin-vs-default.yaml
```

### curl httpbin
Once you have deployed the virtualservice exposing the httpbin app, curl it with the command below:
```
GLOO_EXTERNAL_IP=$(kubectl get svc -n gloo-system | grep gateway-proxy | awk '{print $4}')
curl -v -H "Host: httpbin.solo.io" ${GLOO_EXTERNAL_IP}/headers
```