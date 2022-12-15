## Ingress
The directory structure is as follows:


# ingress-yaml-files
# ├── ingress-service.yaml
# ├── php-apache
# │   └── php-apache.yaml
# └── to-do
#     ├── db-deployment.yaml
#     ├── db-pvc.yaml
#     ├── db-service.yaml
#     ├── web-deployment.yaml
#     └── web-service.yaml

kubectl cluster-info
kubectl get node
cd ingress-yaml-files/
kubectl apply -f to-do
kubectl get svc,deploy,po # open browser, see the page
kubectl apply -f php-apache/
kubectl get svc,deploy,po # open browser, see the page

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.4.0/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f ingress-service.yaml
kubectl get ingress # open browser, see the page
eksctl get cluster --region us-east-1
eksctl delete cluster cw-cluster --region us-east-1
