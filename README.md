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

## argocd
If you have not yet installed argocd, navigate to the `argocd` directory and follow the instructions to install argocd

## installing gloo-edge
Navigate to the `apps/gloo-edge` directory
```
cd apps/gloo-edge
```

Using your favorite text editor, replace the helm value `license_key: <INSERT_LICENSE_KEY_HERE>` in the `gloo-edge-ee-helm.yaml` manifest
```
helm:
      values: |
        license_key: <INSERT_LICENSE_KEY_HERE>
```

Deploy the `gloo-edge-ee-helm.yaml` app
```
kubectl apply -f gloo-edge-ee-helm.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../../wait-for-rollout.sh deployment gateway gloo-system 10
```

Output should look similar to below:
```
$ ../../wait-for-rollout.sh deployment gateway gloo-system 10
Waiting 10 seconds for deployment gateway to come up.
Error from server (NotFound): deployments.apps "gateway" not found
Waiting 20 seconds for deployment gateway to come up.
Waiting for deployment "gateway" rollout to finish: 0 of 1 updated replicas are available...
deployment "gateway" successfully rolled out
Waiting 30 seconds for deployment gateway to come up.
deployment "gateway" successfully rolled out
```

## gloo-fed
gloo-fed is deployed by default as a sub-chart of the `gloo-edge` helm installation. Use this command below to check the status of `gloo-fed` in your cluster
```
../../wait-for-rollout.sh deployment gloo-fed gloo-system 10
```

Output should look similar to below
```
$ ../../wait-for-rollout.sh deployment gloo-fed gloo-system 10
Waiting 10 seconds for deployment gloo-fed to come up.
Waiting 20 seconds for deployment gloo-fed to come up.
Waiting 30 seconds for deployment gloo-fed to come up.
<...>
deployment "gloo-fed" successfully rolled out
```

### registering your cluster to gloo-fed
To register your cluster to `gloo-fed`
```
glooctl cluster register --cluster-name ${CONTEXT} --remote-context ${CONTEXT} --remote-namespace gloo-system
```

### (optional) register a second cluster to gloo-fed
If you have a second cluster you would like to register to the gloo-fed console, follow the steps below

#### IMPORTANT: set correct variables for contexts
For example
```
export MGMT_CONTEXT=cluster1
export REMOTE_CONTEXT=cluster2
```

Then register the remote cluster
```
kubectl config use-context ${MGMT_CONTEXT}
glooctl cluster register --cluster-name ${REMOTE_CONTEXT} --remote-context ${REMOTE_CONTEXT} --remote-namespace gloo-system
```

**Note:** The glooctl command below needs to be run where the gloo fed management plane exists

### port-forward for gloo-fed console
```
kubectl port-forward svc/gloo-fed-console -n gloo-system 8090:8090
```

## installing gloo mesh
Navigate to the `apps/gloo-mesh` directory
```
cd apps/gloo-mesh
```

Using your favorite text editor, replace the helm value `license_key: <INSERT_LICENSE_KEY_HERE>` in the `gloo-mesh-ee-helm.yaml` manifest
```
helm:
      values: |
        license_key: <INSERT_LICENSE_KEY_HERE>
```

Deploy the `gloo-mesh-ee-helm.yaml` app
```
kubectl apply -f gloo-mesh-ee-helm.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../../wait-for-rollout.sh deployment enterprise-networking gloo-mesh 10
```

Output should look similar to below:
```
$ ../../wait-for-rollout.sh deployment enterprise-networking gloo-mesh 10
Waiting 10 seconds for deployment enterprise-networking to come up.
deployment "enterprise-networking" successfully rolled out
Waiting 20 seconds for deployment enterprise-networking to come up.
deployment "enterprise-networking" successfully rolled out
```

### install meshctl
```
curl -sL https://run.solo.io/meshctl/install | sh -
export PATH=$HOME/.gloo-mesh/bin:$PATH
```

### register current cluster istio deployment with gloo mesh using meshctl (useful for kind or local deployments)
To register your cluster to gloo-mesh
```
SVC=$(kubectl --context ${CONTEXT} -n gloo-mesh get svc enterprise-networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
meshctl cluster register --mgmt-context=${CONTEXT} --remote-context=${CONTEXT} --relay-server-address=$SVC:9900 enterprise ${CONTEXT}--cluster-domain cluster.local
```

### (optional) register a second cluster and istio deployment with gloo mesh using meshctl
First set your contexts correctly, for example:
```
$ k config get-contexts
CURRENT   NAME       CLUSTER      AUTHINFO     NAMESPACE
          cluster1   kind-kind1   kind-kind1   
*         cluster2   kind-kind2   kind-kind2   
```

So my context variables would be:
```
export MGMT_CONTEXT=cluster1
export REMOTE_CONTEXT=cluster2
```

Then run:
```
SVC=$(kubectl --context ${MGMT_CONTEXT} -n gloo-mesh get svc enterprise-networking -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
meshctl cluster register --mgmt-context=${MGMT_CONTEXT} --remote-context=${REMOTE_CONTEXT} --relay-server-address=$SVC:9900 enterprise ${REMOTE_CONTEXT} --cluster-domain cluster.local
```

### access gloo mesh dashboard
access gloo mesh dashboard at `http://localhost:8090`:
```
kubectl port-forward -n gloo-mesh svc/dashboard 8090
```

## installing gloo mesh istio
Navigate to the `apps/gm-istio` directory
```
cd apps/gm-istio
```

Deploy the istio-operator app
```
kubectl apply -f istio-operator-1-10-3.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../../wait-for-rollout.sh deployment istio-operator istio-operator 10
```

Output should look similar to below:
```
$ ../../wait-for-rollout.sh deployment istio-operator istio-operator 10
Waiting 10 seconds for deployment istio-operator to come up.
Error from server (NotFound): namespaces "istio-operator" not found
Waiting 20 seconds for deployment istio-operator to come up.
Error from server (NotFound): namespaces "istio-operator" not found
Waiting 30 seconds for deployment istio-operator to come up.
<...>
Waiting for deployment "istio-operator" rollout to finish: 0 of 1 updated replicas are available...
deployment "istio-operator" successfully rolled out
```

Now deploy istio
```
kubectl apply -f gloo-mesh-istio-1-10-3.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress of istiod
```
../../wait-for-rollout.sh deployment istiod istio-system 10
```

Output should look similar to below
```
$ ../../wait-for-rollout.sh deployment istiod istio-system 10
Waiting 10 seconds for deployment istiod to come up.
Waiting for deployment "istiod" rollout to finish: 0 of 1 updated replicas are available...
deployment "istiod" successfully rolled out
Waiting 20 seconds for deployment istiod to come up.
deployment "istiod" successfully rolled out
```

check to see if istio-ingressgateway also was deployed
```
kubectl get pods -n istio-system
```

Output should look similar to below
```
$ kubectl get pods -n istio-system
NAME                                    READY   STATUS    RESTARTS   AGE
istio-ingressgateway-6486dd4ffc-2fjzg   1/1     Running   0          19s
istiod-7f5668c8f7-dm9j6                 1/1     Running   0          30s
```

### install istio-addons
istio-addons provides observability tools (prometheus, grafana, jaeger, kiali) to use for test/dev in non-production environments

Deploy the istio-addons app
```
kubectl apply -f istio-addons.yaml
```

check to see if istio-addons are deployed
```
kubectl get pods -n istio-system
```

Output should look similar to below
```
$ kubectl get pods -n istio-system
NAME                                    READY   STATUS    RESTARTS   AGE
grafana-789c84856f-wdjfw                1/1     Running   0          38m
istio-ingressgateway-6486dd4ffc-h2nxv   1/1     Running   0          46m
istiod-7f5668c8f7-zdm2d                 1/1     Running   0          46m
jaeger-7f8cd55b4c-852qr                 1/1     Running   0          38m
kiali-6457c5bbdc-vpjsh                  1/1     Running   0          38m
prometheus-84446c5697-5h2w2             2/2     Running   0          38m
```

## port-forward commands
access grafana dashboard at `http://localhost:3000`
```
kubectl port-forward svc/grafana -n istio-system 3000:3000
```

access kiali dashboard at `http://localhost:20001`
```
kubectl port-forward deployment/kiali -n istio-system 20001:20001
```

access jaeger dashboard at `http://localhost:16686`
```
kubectl port-forward svc/tracing -n istio-system 16686:80
```

access prometheus dashboard at `http://localhost:9090`
```
kubectl port-forward svc/prometheus -n istio-system 9090:9090
```

## installing gloo portal
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
kubectl apply -f gloo-portal-helm.yaml
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

### access admin UI of Gloo Portal with port-forwarding
access gloo-portal dashboard at `http://localhost:8000`
```
kubectl port-forward -n gloo-portal svc/gloo-portal-admin-server 8000:8080
```