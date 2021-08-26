# bookinfo gloo-edge demo

## bookinfo app architecture
![bookinfo image](https://istio.io/latest/docs/examples/bookinfo/noistio.svg)

### deploy bookinfo-v1 application
Navigate to the `apps/bookinfo/edge` directory
```
cd apps/bookinfo/edge
```

Deploy the bookinfo-v1 app
```
kubectl apply -f 1a-bookinfo-v1.yaml
```

**NOTE:** This app will only have reviews-v2 which is black stars

watch status of bookinfo-v1 deployment
```
kubectl get pods -n bookinfo-v1 -w
```

### deploy bookinfo-beta application

Deploy the bookinfo-beta app
```
kubectl apply -f 1b-bookinfo-beta.yaml
```

**NOTE:** This app will have `reviews-v1` (no reviews), `reviews-v2` (black stars), and `reviews-v3` (red stars)

watch status of bookinfo-beta deployment
```
kubectl get pods -n bookinfo-beta -w
```

## configuring bookinfo virtualservices

**NOTE:** So far, all of the applications that we have been deploying have been Argo Applications that leverage gitops methodology to sync with git as a source of truth. Moving forward we will be configuring the virtualservices for the bookinfo application manually using `kubectl apply -f`. It is fully possible to create Argo Applications for each individual virtualservice so that argocd manages them, but for the purposes of this tutorial it would be easier to learn the basic concepts surrounding virtualservices if we deploy and walk through the configurations manually

Navigate to the `virtualservices` directory
```
cd virtualservices
```

### single route virtualservice
Deploying the manifest below will expose our virtual service using gloo. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 1-bookinfo-vs.yaml
```

#### view your exposed bookinfo-v1 service in the browser
Get your gateway URL
```
glooctl proxy url
```

In your browser navigate to http://$(glooctl proxy url)/productpage

We should expect to see the bookinfo application with just black stars

### traffic splitting
Applying the manifest below will split traffic 50/50 between `bookinfo-v1` and `bookinfo-beta` applications. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 2-bookinfo-vs-multi.yaml
```

### tls
Applying the manifests below will build upon the last example and secure TLS with a `secretRef` to our upstream TLS secret. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 3a-upstream-tls.yaml
kubectl apply -f 3b-bookinfo-tls-multi-vs
```

### extauth
Applying the manifests below will build upon the last example and configure keycloak for extauth. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 4-bookinfo-oidc-tls-multi-vs.yaml
```

### instance rate limit
Applying the manifests below will build upon the last example and add an instance rate limit for authenticated and anonymous users. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 5-bookinfo-irl-oidc-tls-vs.yaml
```

### global rate limit
Applying the manifests below will build upon the last example and switch out the instance rate limit for a global rate limit of 10 requests per minute. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 6a-global-ratelimit-config.yaml
kubectl apply -f 6b-bookinfo-grl-oidc-tls-vs.yaml
```

### waf
Applying the manifests below will build upon the last example add a web application firewall example that will restrict logging into the bookinfo application so that logging in with any numbers (i.e. user123) will result in an error. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 7-bookinfo-waf-grl-oidc-tls-vs.yaml
```

### transformation
Applying the manifests below will build upon the last example and add a transformation that will transform the 429 rate limit error code into a more descriptive and colorful webpage. Feel free to review the manifest for more configuration detail
```
kubectl apply -f 8-bookinfo-trans-waf-grl-oidc-tls-vs.yaml
```