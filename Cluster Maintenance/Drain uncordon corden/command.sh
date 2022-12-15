kubectl drain node01 --ignore-daemonsets #empty the node and mark it unSchedulable.
kubectl uncordon node01 # Configure the node node01 to be schedulable again.
k drain node01 --ignore-daemonsets --force # A forceful drain of the node will delete any pod forever that is not part of a replicaset.
kubectl cordon node01 # This will ensure that no new pods are scheduled on this node and the existing pods will not be affected by this operation.