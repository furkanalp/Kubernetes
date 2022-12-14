kubectl apply -f kubeserve-deployment.yaml
kubectl rollout status deployments kubeserve
kubectl describe deployment kubeserve
kubectl scale deployment kubeserve --replicas=5
kubectl get pods
kubectl expose deployment kubeserve --port 80 --target-port 80 --type NodePort # create a service for kubeserve deployment
kubectl get services
# Start another terminal session logged in to the same Kube Master server
while true; do curl http://<ip-address-of-the-service>; done
# Use this command to perform the update (while the curl loop is running)
kubectl set image deployments/kubeserve app=linuxacademycontent/kubeserve:v2 --v 6
kubectl get replicasets
kubectl get pods
kubectl rollout history deployment kubeserve
