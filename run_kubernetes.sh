#!/usr/bin/env bash
# WARNING! Do not run this file as is!
# This is a collection of the steps to be done
exit

regioncode="eu-central-1"
clustername="UDCapstone"

#--------------------------------------------------
## Crate Kubernetes Cluster in Amazon EKS
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

# This is your Docker ID/path
dockerpath="agostonp/udcapstone-cicd"

# Run the Docker Hub container with kubernetes
#kubectl run udcapstonedemo --image="agostonp/udcapstone-cicd" --port=80
kubectl run udcapstonedemo --image=$dockerpath --port=80 --replicas=2

# List kubernetes pods
kubectl get pods

# Forward the container port to a host
# Listen on port 80 locally, forwarding to 80 in the pod
kubectl port-forward pod/udcapstonedemo 80:80

# A better way of exposing the container to outside
kubectl expose deployment/udcapstonedemo --type="LoadBalancer" --port=80 --target-port=80 --name=udcapstonedemo

# To get the URL of the newly created service
kubectl get service udcapstonedemo

#--------------------------------------------------
##### Non-initial Deployment - when deployment already exists

# Do rolling update
kubectl set image deployment/udcapstonedemo udcapstonedemo=agostonp/udcapstone-cicd:v2

# To roll back the last deployment
kubectl rollout undo deployment/udcapstonedemo
