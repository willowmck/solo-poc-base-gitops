# installing gloo portal

# Prerequisites
- Kubernetes clusters up and authenticated to kubectl
- argocd
- gloo-edge deployed in cluster [follow this guide](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gloo-edge)

Navigate to the `apps/gloo-portal` directory
```
cd apps/gloo-portal
```

Using your favorite text editor, replace the helm value `license_key: <INSERT_LICENSE_KEY_HERE>` in the `gloo-portal-helm.yaml` manifest
```
helm:
      values: |
        glooEdge:
          enabled: true
        istio:
          enabled: false
        glooMesh:
          enabled: false
        licenseKey: 
          value: <INSERT_LICENSE_KEY_HERE>
```

Deploy the `gloo-portal-helm.yaml` app
```
kubectl apply -f 1-gloo-portal-helm.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../../wait-for-rollout.sh deployment gloo-portal-admin-server gloo-portal 10
```

Output should look similar to below:
```
$ ../../wait-for-rollout.sh deployment gloo-portal-admin-server gloo-portal 10
Waiting 10 seconds for deployment gloo-portal-admin-server to come up.
Waiting for deployment "gloo-portal-admin-server" rollout to finish: 0 of 1 updated replicas are available...
deployment "gloo-portal-admin-server" successfully rolled out
Waiting 20 seconds for deployment gloo-portal-admin-server to come up.
deployment "gloo-portal-admin-server" successfully rolled out
```

## (optional) deploy petstore gloo-portal demo app
```
kubectl apply -f 2-petstore-apiproduct-1-0-2.yaml
```

## access admin UI of Gloo Portal with port-forwarding
access gloo-portal dashboard at `http://localhost:8000`
```
kubectl port-forward -n gloo-portal svc/gloo-portal-admin-server 8000:8080
```

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

## cleanup
to remove petstore demo application
```
kubectl delete -f 2-petstore-apiproduct-1-0-2.yaml
kubectl delete -f 1-gloo-portal-helm.yaml
```