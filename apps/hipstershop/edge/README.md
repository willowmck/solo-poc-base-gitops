# hipstershop gloo-edge demo

## deploy hipstershop application
Navigate to the `apps/hipstershop/edge` directory
```
cd apps/hipstershop/edge
```

Deploy the hipstershop-default app
```
kubectl apply -f 1-hipstershop-default.yaml
```

watch status of hipstershop deployment
```
kubectl get pods -n default -w
```

## deploy hipstershop virtualservice and validate
```
kubectl apply -f 2-hipstershop-vs.yaml
```

check glooctl
```
glooctl get vs
```

output should look similar to below:
```
$ glooctl get vs
+-----------------+--------------+---------+------+----------+-----------------+---------------------------------+
| VIRTUAL SERVICE | DISPLAY NAME | DOMAINS | SSL  |  STATUS  | LISTENERPLUGINS |             ROUTES              |
+-----------------+--------------+---------+------+----------+-----------------+---------------------------------+
| hipstershop-vs  |              | *       | none | Accepted |                 | / ->                            |
|                 |              |         |      |          |                 | gloo-system.default-frontend-80 |
|                 |              |         |      |          |                 | (upstream)                      |
+-----------------+--------------+---------+------+----------+-----------------+---------------------------------+
```

Run a `glooctl check`
```
$ glooctl check
Checking deployments... OK
Checking pods... OK
Checking upstreams... OK
Checking upstream groups... OK
Checking auth configs... OK
Checking rate limit configs... OK
Checking VirtualHostOptions... OK
Checking RouteOptions... OK
Checking secrets... OK
Checking virtual services... OK
Checking gateways... OK
Checking proxies... OK
Checking rate limit server... OK
No problems detected.

Detected Gloo Federation!
Checking Gloo Instance cluster3-gloo-system... 
Checking deployments... OK
Checking pods... OK
Checking settings... OK
Checking upstreams... OK
Checking upstream groups... OK
Checking auth configs... OK
Checking virtual services... OK
Checking route tables... OK
Checking gateways... OK
Checking proxies... OK
```

## navigate to hipstershop application
get the envoy proxy url
```
glooctl proxy url
```

output should look similar to below:
```
$ glooctl proxy url
http://172.18.3.1:80
```

## cleanup
to remove hipstershop application
```
kubectl delete -f 2-hipstershop-vs.yaml
kubectl delete -f 1-hipstershop-default.yaml
```
