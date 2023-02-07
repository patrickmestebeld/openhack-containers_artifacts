# List az locations
az account list-locations -o table

# Create new resource group 
az group create --name patrickResourceGroup --location northeurope

# Create a cluster
az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-managed-identity --node-count 1 --enable-addons monitoring --enable-msi-auth-for-monitoring --generate-ssh-keys --attach-acr registryavj6801

# Switch login Kubernetes to current
az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster

# Get nodes
kubectl get nodes

# K8 apply resources by file 
kubectl apply -f ./k8s/trips-cluster.yaml