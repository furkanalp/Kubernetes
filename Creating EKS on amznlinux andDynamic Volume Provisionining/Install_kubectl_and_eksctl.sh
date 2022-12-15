### Install kubectl
sudo yum update -y
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

### Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/v0.111.0/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

## Creating the Kubernetes Cluster on EKS
ssh-keygen -f ~/.ssh/id_rsa #If needed create ssh-key
# give AdministratorAccess or your aws credentials(aws configure)
eksctl create cluster \
 --name cw-cluster \
 --region us-east-1 \
 --zones us-east-1a,us-east-1b,us-east-1c \
 --nodegroup-name my-nodes \
 --node-type t3a.medium \
 --nodes 2 \
 --nodes-min 2 \
 --nodes-max 3 \
 --ssh-access \
 --ssh-public-key  ~/.ssh/id_rsa.pub \
 --managed

 ##  Dynamic Volume Provisionining
 code storage-class.yaml
 kubectl apply -f storage-class.yaml
 kubectl get sc
 code clarus-pv-claim.yaml
 kubectl apply -f clarus-pv-claim.yaml
 kubectl get pv,pvc
 code pod-with-dynamic-storage.yaml
 kubectl apply -f pod-with-dynamic-storage.yaml
 kubectl exec -it test-aws -- bash # df -h and see that ebs is mounted to /usr/share/nginx/html path.
 kubectl delete storageclass aws-standard
 kubectl delete -f pod-with-dynamic-storage.yaml

