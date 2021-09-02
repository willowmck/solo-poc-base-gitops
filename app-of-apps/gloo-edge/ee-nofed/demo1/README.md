# ee-nofed demo1 environment details

To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-edge/ee-nofed/demo1/gloo-edge-ee-nofed-demo1-aoa.yaml
```

## active applications
This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-edge/ee-nofed/demo1/active` directory:
- Gloo Edge Enterprise with Gloo Federation Disabled
- httpbin application

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.