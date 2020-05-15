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
./cfcreate.sh udcapstone-cluster ./kubecluster.yml ./environment-params.json

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

# This is your Docker ID/path
dockerpath="agostonp/udproj-kubernetes:uploaded"

# Run the Docker Hub container with kubernetes
#kubectl run udprojkubedemo --image="agostonp/udproj-kubernetes:uploaded" --port=8000 --generator="run-pod/v1"
kubectl run udprojkubedemo --image=$dockerpath --port=8000 --generator=run-pod/v1

# List kubernetes pods
kubectl get pods

# Forward the container port to a host
# Listen on port 8000 locally, forwarding to 80 in the pod
kubectl port-forward pod/udprojkubedemo 8000:80

