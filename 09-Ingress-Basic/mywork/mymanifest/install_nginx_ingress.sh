# Create a static public ip 
az network public-ip create --resource-group MC_aksdemo-rg_aksdemo-01_eastus \
                           --name aksdemo-01_PublicIP \
                           --sku Standard \
                           --allocation-method static \
                           --query publicIp.ipAddress \
                           -o tsv
52.188.144.165

# Install ingress controller and associate the public ip, create the ingress resource in ingress-basic namespace
#   This creates the pod and the service for ingress
        # i) Create the namespace
            kubectl create ns ingress-nginx
        # ii) add the official stable repo
            helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
            helm repo add stable https://kubernetes-charts.storage.googleapis.com/
            helm repo update
        # using helm to deploy an NGINX ingress controller
            helm install ingress-nginx ingress-nginx/ingress-nginx \
                    --namespace ingress-nginx \
                    --set controller.replicaCount=2 \
                    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
                    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
                    --set contoller.service.externalTrafficPolicy=Local \
                    --set controller.service.loadBalancerIP="52.188.144.165"


# Done