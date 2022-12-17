#Look up the value for the key cluster.name in the etcd cluster:

ETCDCTL_API=3 etcdctl get cluster.name \
  --endpoints=https://10.0.1.101:2379 \ # this is the private IP.
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key
#The returned value should be beebox.

#Back up etcd using etcdctl and the provided etcd certificates: 

ETCDCTL_API=3 etcdctl snapshot save /home/cloud_user/etcd_backup.db \ # where we're going to be storing our backup
  --endpoints=https://10.0.1.101:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key

ls # see etcd_backup.db


#Reset etcd by removing all existing etcd data:
sudo systemctl stop etcd
sudo rm -rf /var/lib/etcd

#Restore the etcd data from the backup (this command spins up a temporary etcd cluster, /
#saving the data from the backup file to a new data directory in the same location where the previous data directory was):

sudo ETCDCTL_API=3 etcdctl snapshot restore /home/cloud_user/etcd_backup.db \
  --initial-cluster etcd-restore=https://10.0.1.101:2380 \
  --initial-advertise-peer-urls https://10.0.1.101:2380 \
  --name etcd-restore \
  --data-dir /var/lib/etcd

#Set ownership on the new data directory:

sudo chown -R etcd:etcd /var/lib/etcd

#Start etcd:

sudo systemctl start etcd

#Verify the restored data is present by looking up the value for the key cluster.name again:
ETCDCTL_API=3 etcdctl get cluster.name \
  --endpoints=https://10.0.1.101:2379 \
  --cacert=/home/cloud_user/etcd-certs/etcd-ca.pem \
  --cert=/home/cloud_user/etcd-certs/etcd-server.crt \
  --key=/home/cloud_user/etcd-certs/etcd-server.key