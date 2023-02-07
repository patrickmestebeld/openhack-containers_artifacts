# List az locations
`az account list-locations -o table`

# Create new resource group 
`az group create --name patrickResourceGroup --location northeurope`

# Create a cluster
`az aks create -g patrickResourceGroup -n patrickAKSCluster --enable-managed-identity --node-count 1 --enable-addons monitoring --enable-msi-auth-for-monitoring  --generate-ssh-keys`

# Login to Kubernetes
`az aks get-credentials --resource-group patrickResourceGroup --name patrickAKSCluster`
`az aks get-credentials --resource-group teamResources --name myTeam6AKSCluster`

# Attach an ACR from an AKS cluster
`az aks update -n patrickAKSCluster -g patrickResourceGroup --attach-acr registryavj6801`

# Get nodes
`kubectl get nodes`

# K8 apply resources by file 
`kubectl apply -f ./deployments/azure-vote.yaml`
`kubectl apply -f ./deployments/tips-cluster.yaml`

# Port forwarding (gebruik localhost om de port te bekijken)
`kubectl port-forward <<pod-id>> <<outside-port>>:<<inside-port>>`

# K8 delete resources by file
`kubectl delete -f ./deployments/azure-vote.yaml`
`kubectl delete -f ./deployments/tips-cluster.yaml`

# Set this variable to the name of your ACR. The name must be globally unique.

# Detach an ACR from an AKS cluster
`az aks update -n myAKSCluster -g myResourceGroup --detach-acr <acr-name>`