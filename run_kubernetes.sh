#!/usr/bin/env bash
echo 'WARNING! I suggest not to run this file as is at first!'
echo 'Run step by step and confirm success after every step'
exit

regioncode="eu-central-1"
clustername="UDCapstone"

#--------------------------------------------------
## Create Kubernetes Cluster in Amazon EKS
cd infrastructure

# Create the iam roles
./cfcreate.sh udcapstone-iam ./iam.yml ./environment-params.json
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-iam

# Create the private network elements
./cfcreate.sh udcapstone-pri-network ./private-network.yml ./network-params.json
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-pri-network

# Create the cluster
./cfcreate.sh udcapstone-cluster ./kubecluster.yml ./kubecluster-params.json
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-cluster

# Add the new cluster to the kubeconfig file
aws eks --region "eu-central-1" update-kubeconfig --name UDCapstone

kubectl get svc

cd ..


#--------------------------------------------------
##### Initial Deployment

# Add variables
dockerimage=udcapstone-cicd
repopath=857339242870.dkr.ecr.eu-central-1.amazonaws.com/$dockerimage
containername=udcapstonedemo
echo "Repo path and Docker Image: $repopath"

# Add the new cluster to the kubeconfig file
aws eks --region "eu-central-1" update-kubeconfig --name UDCapstone

kubectl get svc

# Run the Docker Hub container with kubernetes
#kubectl run udcapstonedemo --image="agostonp/udcapstone-cicd" --port=8000

# Run the Docker container in Amazon ECR with kubernetes
#kubectl run $containername --image=$repopath:jenkins-udcapstone-cicd-master-21 --port=8000 --replicas=2
kubectl create -f ./kube-deployment.yml

# Wait until the pods are created and reach running state
for VARIABLE in 1 2 3 4 5
do
    sleep 10
    # List kubernetes pods and see their status
    kubectl get pods
done

# Forward the container port to a host
# Listen on port 80 locally, forwarding to 80 in the pod
#kubectl port-forward pod/udcapstonedemo 80:80

# A better way of exposing the container to outside
kubectl expose deployment/$containername --type="LoadBalancer" --port=80 --target-port=8000 --name=$containername

# To get the URL of the newly created service
kubectl get service $containername
# NAME             TYPE           CLUSTER-IP    EXTERNAL-IP                                                                  PORT(S)        AGE
# udcapstonedemo   LoadBalancer   172.20.89.0   a04541a653190440ba76e2851e899985-2062291876.eu-central-1.elb.amazonaws.com   80:32329/TCP   7s

#--------------------------------------------------
##### Non-initial Deployment - when deployment already exists

# Do rolling update
#kubectl set image deployment/$containername $containername=$repopath:jenkins-udcapstone-cicd-master-22

# List kubernetes pods
#kubectl get pods

# To roll back the last deployment - if needed
#kubectl rollout undo deployment/$containername

#--------------------------------------------------
##### Cleanup

# kubectl delete services/$containername
# kubectl delete deployment/$containername
