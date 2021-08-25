## installing gloo mesh
Navigate to the `apps/gloo-mesh` directory
```
cd apps/gloo-mesh
```

Using your favorite text editor, replace the helm value `license_key: <INSERT_LICENSE_KEY_HERE>` in the `1-gloo-mesh-ee-helm.yaml` manifest
```
helm:
      values: |
        license_key: <INSERT_LICENSE_KEY_HERE>
```

Deploy the `gloo-mesh-ee-helm.yaml` app
```
kubectl apply -f 1-gloo-mesh-ee-helm.yaml
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

## Next Steps - Deploy gloo-mesh istio
[Follow this Tutorial Here](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/gm-istio)