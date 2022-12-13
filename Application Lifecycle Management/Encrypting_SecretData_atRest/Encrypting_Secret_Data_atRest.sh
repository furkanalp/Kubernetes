kubectl create secret generic my-secret --from-literal=key1=supersecret
k get secret
apt-get install etcd-client
k get pods -n kube-system # check the etcd-controlplane
---
ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/my-secret | hexdump -C
---
ps -aux | grep kube-api | grep "encryption-provider-config" # check if encryption at rest is already enabled.
---
head -c 32 /dev/urandom | base64 # get the key e.i= alskdhfalsdh2635jsb=
---> # vi enc.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - secrets
    providers:
      - identity: {}
      - aescbc:
          keys:
            - name: key1
              secret: alskdhfalsdh2635jsb=
# :wq

mkdir /etc/kubernetes/enc
mv enc.yaml /etc/kubernetes/enc/
vi /etc/kubernetes/manifests/kube-apiserver.yaml
-->> - --encryption-provider-config=/etc/kubernetes/enc/enc.yaml # add this line under the command section of kube-apiserver.yaml to show where the encyrption file is.
-->> name: enc
     mountPath: /etc/kubernetes/enc
     readOnly: true
     # add this part under volumeMounts of container also.
-->> name: enc
     hostPath:
        path: /etc/kubernetes/enc
        type: Directory0rCreate  # add this part under volumes 
---

ps -aux | grep kube-api | grep encry # check

kubectl create secret generic my-secret-2 --from-literal=key2=topsecret

ETCDCTL_API=3 etcdctl \
   --cacert=/etc/kubernetes/pki/etcd/ca.crt   \
   --cert=/etc/kubernetes/pki/etcd/server.crt \
   --key=/etc/kubernetes/pki/etcd/server.key  \
   get /registry/secrets/default/my-secret-2 | hexdump -C # and you can no longer see the topsecret, since encryption is enabled. But you can see supersecret because that was created before the encryption.

kubectl get secrets --all-namespaces -o json | kubectl replace -f - # now all of them is encrypted.