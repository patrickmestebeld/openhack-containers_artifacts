# Update Commands

## Execute .ps1 by user
`Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser`

## Cluster updates
### Attach an ACR from an AKS cluster
`az aks update -n patrickAKSCluster -g patrickResourceGroup --attach-acr registryavj6801`
# Detach an ACR from an AKS cluster
`az aks update -n patrickAKSCluster -g patrickResourceGroup --detach-acr registryavj6801`

### To disable local account on existing cluster use:
`az aks update -g patrickResourceGroup -n patrickAKSCluster --enable-aad --aad-admin-group-object-ids <aad-group-id> --disable-local-accounts`
### To enable local accounts on existing cluster use;
`az aks update -g patrickResourceGroup -n patrickAKSCluster --enable-aad --aad-admin-group-object-ids <aad-group-id> --enable-local`

### Port forwarding (gebruik localhost om de port te bekijken)
`kubectl port-forward <<pod-id>> <<outside-port>>:<<inside-port>>`