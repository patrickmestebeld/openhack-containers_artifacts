## Create AD group
Write-Host '# Create an AD Admin group. (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup';
az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup

## Create new resource group 
Write-Host '# Create a new resource group.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az group create --name patrickResourceGroup --location northeurope';
az group create --name patrickResourceGroup --location northeurope

# Create a cluster
Write-Host '=> Create a Kubernetes cluster.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-managed-identity --node-count 1 --enable-addons monitoring --enable-msi-auth-for-monitoring --generate-ssh-keys --attach-acr registryavj6801

# Switch login Kubernetes to current
Write-Host '=> Switch login Kubernetes to current.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster

## K8s apply resources by files 
Write-Host '# Apply Kubernetes resources files.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> kubectl apply -f ./k8s/secret.yaml';
kubectl apply -f ./k8s/secret.yaml
Write-Host '=> kubectl apply -f ./k8s/trips-cluster.yaml';
kubectl apply -f ./k8s/trips-cluster.yaml