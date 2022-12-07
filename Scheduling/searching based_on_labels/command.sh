kubectl get all -l env=prod --no-headers | wc -l
kubectl get all --selector env=prod --no-headers | wc -l
kubectl get all --selector env=prod,bu=finance,tier=frontend