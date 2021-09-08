# VM Integration with Istio 
This example show how to orchestrate VM integration with Istio via Argo Workflows.

## Prerequisites
You will need an existing cluster running Istio that is managed by Gloo Mesh.
You will also need a VM that is deployed into the same VPC that is accessible from the cluster.

## Overview
This workflow will install bookinfo into the VM namespace.

Rather than using your local workstation to access the cluster, all work will be performed within the workflow.  Any storage needs will be performed with GCloud storage.

The following variables will be set:
- **VM_APP** = bookinfo
- **VM_NAMESPACE** = bookinfo
- **WORK_DIR** = /workdir (a mounted volume)
- **SERVICE_ACCOUNT** = vmsa
- **CLUSTER_NETWORK** = kube-network
- **VM_NETWORK** = vm-network
- **CLUSTER** = cluster1