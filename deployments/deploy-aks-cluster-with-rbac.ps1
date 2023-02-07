## for more information see:
## https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac
## https://learn.microsoft.com/en-us/azure/aks/managed-aad 

## Create AD group
Write-Host 'Creating AD Admin group.';
Write-Host 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup

## Create new resource group 
Write-Host '=> Creating a new resource group.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az group create --name patrickResourceGroup --location northeurope

## Create an AKS-managed Azure AD cluster 
## To create cluster without local account add `--disable-local-accounts` to command.
Write-Host '=> Creating an AKS-managed Azure AD cluster and attach Role.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-aad --enable-azure-rbac --attach-acr registryavj6801

## Add an AKS-managed Azure AD to existing cluster
# az aks update -g myResourceGroup -n myAKSCluster --enable-azure-rbac
## Remove an AKS-managed Azure AD cluster
# az aks update -g myResourceGroup -n myAKSCluster --disable-azure-rbac
$AD_GROUP_OBJECT_ID = $(az ad group list --query "[?displayName == 'patrickAKSAdminGroup'].id" --output tsv)
$AKS_ID=$(az aks show -g patrickResourceGroup -n patrickAKSCluster --query id -o tsv)
az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee $AD_GROUP_OBJECT_ID --scope $AKS_ID

# Switch login Kubernetes to current
Write-Host '=> Switch login Kubernetes to current.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster

## K8s apply resources by files 
Write-Host '=> K8s apply resources by files.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
kubectl apply -f ./k8s/secret.yaml
kubectl apply -f ./k8s/trips-cluster.yaml