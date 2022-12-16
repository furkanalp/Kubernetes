kubectl logs etcd-contolplane -n kube-system | grep -i etcd-version # see etcd version
kubectl describe pod etcd-controlplane -n kube-system | grep -i listen-client # This means that ETCD is reachable on localhost (127.0.0.1) at port 2379.
kubectl describe pod etcd-controlplane -n kube-system | grep -i cert-file # ETCD server certificate file location.
kubectl describe pod etcd-controlplane -n kube-system | grep -i ca-file # ETCD CA Certificate file location.

# taking snapshot for ETCD
ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
--cacert=/etc/kubernetes/pki/etcd/ca.crt \
--cert=/etc/kubernetes/pki/etcd/server.crt \
--key=/etc/kubernetes/pki/etcd/server.key \
snapshot save /opt/snapshot-pre-boot.db # give location to save

# restoring snapshot
ETCDCTL_API=3 etcdctl  --data-dir /var/lib/etcd-from-backup \
snapshot restore /opt/snapshot-pre-boot.db

# We have now restored the etcd snapshot to a new path on the controlplane - /var/lib/etcd-from-backup

-----
cd /etc/kubernetes/manifests/
vi etcd.yaml
volumes:
  - hostPath:
      path: /var/lib/etcd-from-backup # change here so.
      type: DirectoryOrCreate
    name: etcd-data

# If you do change --data-dir to /var/lib/etcd-from-backup in the ETCD YAML file, make sure that the volumeMounts for etcd-data is updated as well, with the mountPath pointing to /var/lib/etcd-from-backup under command section not volumeMounts !!!

kubectl get pods -n kube-system --watch # it will take a few time to be in running state for etcd-controlplane
