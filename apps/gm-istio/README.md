# gloo mesh istio builds

## Prerequisites
- Kubernetes clusters up and authenticated to kubectl
- argocd

## installing gloo mesh istio
Navigate to the `apps/gm-istio` directory
```
cd apps/gm-istio
```

Deploy the istio-operator app
```
kubectl apply -f 1-istio-operator-1-10-3.yaml
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
kubectl apply -f 2-gloo-mesh-istio-1-10-3.yaml
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
kubectl apply -f 3-istio-addons.yaml
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

## Next Steps - Deploy hipstershop application and expose through istio
[Follow this Tutorial Here](https://github.com/ably77/solo-poc-base-gitops/tree/main/apps/hipstershop/istio)