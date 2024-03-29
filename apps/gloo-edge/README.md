# gloo-edge

## Prerequisites
- Kubernetes clusters up and authenticated to kubectl
- argocd

## kubectl contexts
Since we will potentially be using multiple clusters/contexts, it is useful to rename your contexts for a better experience
```
kubectl config get-contexts
kubectl config rename-contexts <current_name> <new_name>
export CONTEXT=<new_name>
```

## installing gloo-edge
Navigate to the `apps/gloo-edge` directory
```
cd apps/gloo-edge
```

Using your favorite text editor, replace the helm value `license_key: <INSERT_LICENSE_KEY_HERE>` in the `1-gloo-edge-ee-helm.yaml` manifest
```
helm:
      values: |
        license_key: <INSERT_LICENSE_KEY_HERE>
```

Deploy the `gloo-edge-ee-helm.yaml` app
```
kubectl apply -f 1-gloo-edge-ee-helm.yaml
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

## configuring gloo-fed
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

## installing keycloak
If you plan to follow along with the guides, it is recommended to install the keycloak argo application as well

Deploy the `2-keycloak-12-0-4.yaml` app
```
kubectl apply -f 2-keycloak-12-0-4.yaml
```

You can run the `wait-for-rollout.sh` script to watch deployment progress
```
../../wait-for-rollout.sh deployment keycloak default 10
```

## setting up keycloak
Run the script below to set up keycloak with two users `user1/password` and `user2/password`
```
./3-keycloak-setup.sh
```

## Next Steps - Deploy hipstershop application and expose through gloo-edge
[Follow this Tutorial Here](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/hipstershop/edge)