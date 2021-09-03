# gloo-portal + gloo-edge environment details

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

## Deploying gloo-portal edge app-of-app environment
To deploy this app-of-app environment, from the root folder just run the command below:
```
kubectl create -f app-of-apps/gloo-portal/edge/gloo-portal-edge-aoa.yaml
```

This app-of-app will deploy all of the argo apps that have been predefined in the `app-of-apps/gloo-portal/edge/active` directory:
- Gloo Portal with integration to Gloo Edge
- Petstore swagger APIdoc
- Petstore swagger APIproduct
- Petstore Developer Portal

# Access admin UI of Gloo Portal with port-forwarding
```
kubectl port-forward -n gloo-portal svc/gloo-portal-admin-server 8000:8080
```

Open (localhost:8000) in browser

# login to petstore portal htpasswd auth user
```
username: developer1
password: gloo-portal1
```

# for kind deployments: update /etc/hosts file to be able to access our API (and later the Portal)
```
cat <<EOF | sudo tee -a /etc/hosts
$(kubectl -n gloo-system get service gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}') portal.mycompany.corp
$(kubectl -n gloo-system get service gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}') api.mycompany.corp
EOF
```

## non-active applications
In `non-active` directory you will find a couple example argocd applcations that you can manually invoke. Once comfortable with the outcome, if you have access to the github repo you can push a an addition of any service in `non-active` to `active` to have argoCD automatically sync in its next loop.

### Examples to follow

