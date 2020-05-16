#!/usr/bin/env bash

regioncode="eu-central-1"
clustername="UDCapstone"

#--------------------------------------------------
## Crate Kubernetes Cluster in Amazon EKS
cd infrastructure

# Create the iam roles
./cfcreate.sh udcapstone-iam ./iam.yml ./environment-params.json

# Create the network elements
./cfcreate.sh udcapstone-network ./network.yml ./network-params.json

# Create the cluster
./cfcreate.sh udcapstone-cluster ./kubecluster.yml ./kubecluster-params.json

# Add the new cluster to the kubeconfig file
aws eks --region "eu-central-1" update-kubeconfig --name UDCapstone

kubectl get svc

cd ..




#--------------------------------------------------
# Create an Amazon EKS cluster with Fargate support
eksctl version
eksctl create cluster --name udcapstone --region "eu-central-1" --fargate

# configure kubectl to use the same IAM Role
aws --region "eu-central-1" eks update-kubeconfig --name udcapstone --role-arn arn:aws:iam::857339242870:role/eksctl-udcapstone-cluster-FargatePodExecutionRole-1VUQRGJXM8F88




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
