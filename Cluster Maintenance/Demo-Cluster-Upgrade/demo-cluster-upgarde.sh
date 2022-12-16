# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
#controlplane
kubectl cluster-info
kubectl get nodes # v1.18.0
cat /etc/*release # see, we are on ubuntu OS
apt update
apt-cache madison kubeadm # see which versions are available for upgrading

apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.19.6-00 && \
apt-mark hold kubeadm

kubeadm version
kubeadm upgrade plan
sudo kubeadm upgrade apply v1.19
kubeadm upgrade plan # there are no more upgrade recommendations.

kubectl get nodes # version is still v1.18.0 because kubelet hasn't been upgraded.
kubectl drain controlplane --ignore-daemonsets

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.19.6-00 kubectl=1.19.6-00 && \
apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl get nodes # now you can see the exact version.
kubectl uncordon controlplane
kubectl get nodes # we see that the node is now ready.


# node01
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.19.6-00 && \
apt-mark hold kubeadm

sudo kubeadm upgrade node
kubectl drain node01 --ignore-daemonsets # Remember to run it on the control plane node !!!!

apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.19.6-00 kubectl=1.19.6-00 && \
apt-mark hold kubelet kubectl

sudo systemctl daemon-reload
sudo systemctl restart kubelet

kubectl uncordon node01 # Remember to run it on the control plane node !!!!
