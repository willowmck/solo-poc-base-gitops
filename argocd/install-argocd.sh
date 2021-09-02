#!/bin/bash

CONTEXT=$1

### If the CONTEXT is not specified, simply use the default context.
if [[ ${CONTEXT} == "" ]]
then
  CONTEXT=`kubectl config current-context`
  if [[ ${CONTEXT} == "" ]]
  then
    echo "You do not have a curent kubernetes cluster.  Please create one."
    exit 1
  fi
  echo "No context specified. Using default context of ${CONTEXT}"
fi
  
echo "Beginning install on context ${CONTEXT}...."

# use context
kubectl config use-context ${CONTEXT}

# create argocd namespace
kubectl --context ${CONTEXT} create namespace argocd

# deploy argocd
until kubectl --context ${CONTEXT} apply -k https://github.com/ably77/solo-testbed-apps.git/kustomize/instances/overlays/platform/argocd/; do sleep 2; done

# wait for argo cluster rollout
../wait-for-rollout.sh deployment argocd-server argocd 10

# bcrypt(password)=$2a$10$79yaoOg9dL5MO8pn8hGqtO4xQDejSEVNWAGQR268JHLdrCw6UCYmy
# password: solo.io
kubectl --context ${CONTEXT} -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$79yaoOg9dL5MO8pn8hGqtO4xQDejSEVNWAGQR268JHLdrCw6UCYmy",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'