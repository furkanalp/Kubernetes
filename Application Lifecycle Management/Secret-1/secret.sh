echo -n 'admin' > ./username.txt
echo -n '1f2d1e2e67df' > ./password.txt
kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
kubectl create secret generic db-user-pass-key --from-file=username=./username.txt --from-file=password=./password.txt
kubectl create secret generic dev-db-secret --from-literal=username=devuser --from-literal=password='S!B\*d$zDsb='
kubectl get secrets
kubectl describe secret db-user-pass

### Creating a Secret manually
echo -n 'admin' | base64 # YWRtaW4=
echo -n '1f2d1e2e67df' | base64 # MWYyZDFlMmU2N2Rm
code secret.yaml

#decoding
echo 'MWYyZDFlMmU2N2Rm' | base64 --decode # 1f2d1e2e67df

### Using Secrets
code mysecret-pod.yaml
k apply -f mysecret-pod.yaml
k delete -f mysecret-pod.yaml

# This time we get the environment variables from secret objects. Modify the mysecret-pod.yaml
k apply -f mysecret-pod.yaml





