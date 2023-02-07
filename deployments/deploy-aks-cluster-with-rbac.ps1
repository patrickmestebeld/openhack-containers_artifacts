## for more information see:
## https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac
## https://learn.microsoft.com/en-us/azure/aks/managed-aad 

## Create AD group
Write-Host '# Create an AD Admin group. (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup';
az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup

## Create new resource group 
Write-Host '# Create a new resource group. (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az group create --name patrickResourceGroup --location northeurope';
az group create --name patrickResourceGroup --location northeurope

## Create an AKS-managed Azure AD cluster 
## To create cluster without local account add `--disable-local-accounts` to command.
Write-Host '# Create an AKS-managed Azure AD cluster and attach Role. (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-aad --enable-azure-rbac --attach-acr registryavj6801';
az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-aad --enable-azure-rbac --attach-acr registryavj6801

$AD_GROUP_OBJECT_ID = $(az ad group list --query "[?displayName == 'patrickAKSAdminGroup'].id" --output tsv)
$AKS_ID=$(az aks show -g patrickResourceGroup -n patrickAKSCluster --query id -o tsv)
az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee $AD_GROUP_OBJECT_ID --scope $AKS_ID

# Switch login Kubernetes to current
Write-Host '# Switch login Kubernetes to current.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster';
az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster

## K8s apply resources by files 
Write-Host '# Apply Kubernetes resources files.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> kubectl apply -f ./k8s/secret.yaml';
kubectl apply -f ./k8s/secret.yaml
Write-Host '=> kubectl apply -f ./k8s/trips-cluster.yaml';
kubectl apply -f ./k8s/trips-cluster.yaml