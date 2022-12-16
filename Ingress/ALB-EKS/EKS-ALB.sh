sudo yum update -y
aws --version

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

sudo rm /usr/bin/aws
aws --version # change terminal
sudo yum install git -y

curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version --short

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

ssh-keygen -f ~/.ssh/id_rsa
aws configure # or you can give adminastratorfullaccess

eksctl create cluster \
 --name cwcluster \
 --version 1.23 \
 --region us-east-1 \
 --zones us-east-1a,us-east-1b,us-east-1c \
 --nodegroup-name my-nodes \
 --node-type t3a.medium \
 --nodes 1 \
 --nodes-min 1 \
 --nodes-max 2 \
 --ssh-access \
 --ssh-public-key  ~/.ssh/id_rsa.pub \
 --managed

 curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
 aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
  --cluster=cwcluster \
  --region=us-east-1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name "AmazonEKSLoadBalancerControllerRole" \
  --attach-policy-arn=arn:aws:iam::046402772087:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=cwcluster --approve

helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=cwcluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

kubectl get deployment -n kube-system aws-load-balancer-controller

kubectl cluster-info
kubectl get node

scp -i <pem-file> -r <eks-03-AWS-EKS-ALB-ingress/k8s> ec2-user@<ec2-instance-public-ip>:~/k8s

code ingress.yaml # create ingress yaml
kubectl apply -f k8s
kubectl apply -f ingress.yaml # Create an `A record` for your host on `route53 service`

kubectl get ingress
eksctl get cluster
eksctl delete cluster cwcluster