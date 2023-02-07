## for more information see:
## https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac
## https://learn.microsoft.com/en-us/azure/aks/managed-aad 

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

## Create public-ip 
# Write-Host '=> Create public-ip.';
# Write-Host '   Press any key to continue...';
# $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
# az network public-ip create `
#     --resource-group patrickResourceGroup `
#     --name patrickAKSPublicIP `
#     --sku Standard `
#     --allocation-method static

# Write-Host 'Public IP:'
# az network public-ip show --resource-group patrickResourceGroup --name patrickAKSPublicIP --query ipAddress --output tsv
# Write-Host '=> Open file ./k8s/trips-cluster.yaml and replace the <loadBalancerIP> by the given public-ip';
# Write-Host '   Press any key to continue...';

## Create a virtual network and subnet
Write-Host '# Create a virtual network and subnet.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az network vnet create...';
az network vnet create `
    --name patrickVNet `
    --resource-group patrickResourceGroup `
    --address-prefixes 10.150.0.0/16  `
    --location northeurope

Write-Host '=> az network vnet subnet create...';
az network vnet subnet create `
    --resource-group patrickResourceGroup `
    --vnet-name patrickVNet `
    --name patrickAKSSubnet `
    --address-prefixes 10.150.20.0/24

$SUBNET_ID=$(az network vnet subnet show --resource-group patrickResourceGroup --vnet-name patrickVNet --name patrickAKSSubnet --query id -o tsv)

## Create an AKS-managed Azure AD cluster 
## To create cluster without local account add `--disable-local-accounts` to command.
Write-Host '# Create an AKS-managed Azure AD cluster in subnet and attach Role.  (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az aks create ...';
az aks create `
    --resource-group patrickResourceGroup `
    --name patrickAKSCluster `
    --network-plugin azure `
    --vnet-subnet-id $SUBNET_ID `
    --docker-bridge-address 172.17.0.1/16 `
    --dns-service-ip 10.240.0.10 `
    --service-cidr 10.240.0.0/24 `
    --enable-aad `
    --enable-azure-rbac `
    --attach-acr registryavj6801

$AD_GROUP_OBJECT_ID = $(az ad group list --query "[?displayName == 'patrickAKSAdminGroup'].id" --output tsv)
$AKS_ID=$(az aks show -g patrickResourceGroup -n patrickAKSCluster --query id -o tsv)
Write-Host '=> az role assignment create';
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