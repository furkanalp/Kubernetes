cat /etc/kubernetes/manifests/kube-apiserver.yaml
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd-certfile
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep kubelet
cat /etc/kubernetes/manifests/etcd.yaml | grep cert-file
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text
openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text
openssl x509 -in /etc/kubernetes/pki/ca.crt -text