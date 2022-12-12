# create --> kubectl create -f deployment-definition.yml
# get----> kubectl get deployments
# update ---> kubectl apply -f deployment.yml
#        ---> kubectl set image deployment/myapp-deployment nginx=nginx:1.9.1 (k set image deploy frontend simple-webapp=kodekloud/webapp-color:v3)
# status ---> kubectl rollout status deployment/myapp-deployment
#        ---> kubectl rollout history deployment/myapp-deployment
# rollback ---> kubectl rollout undo deployment/myapp-deployment

