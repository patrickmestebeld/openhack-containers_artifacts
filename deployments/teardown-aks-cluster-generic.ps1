# Cleanup Cluster
Write-Host '=> Delete whole resource group.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

# K8 delete resources by file
Write-Host '=> kubectl delete -f ./k8s/trips-roles.yaml';
kubectl delete -f ./k8s/trips-roles.yaml
Write-Host '=> kubectl delete -f ./k8s/trips-cluster.yaml';
kubectl delete -f ./k8s/trips-cluster.yaml
Write-Host '=> kubectl delete -f ./k8s/secret.yaml';
kubectl delete -f ./k8s/secret.yaml

## Delete resource-group
Write-Host '=> az group delete --name patrickResourceGroup --yes';
az group delete --name patrickResourceGroup --yes
