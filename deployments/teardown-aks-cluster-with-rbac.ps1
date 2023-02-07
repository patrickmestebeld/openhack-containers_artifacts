# Cleanup
# K8 delete resources by file
kubectl delete -f ./deployments/tips-cluster.yaml

## Delete group
az group delete --name patrickAKSAdminGroup --yes --no-wait