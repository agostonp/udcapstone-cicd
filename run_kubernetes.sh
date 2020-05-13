#!/usr/bin/env bash

# This tags and uploads an image to Docker Hub

# Step 1:
# This is your Docker ID/path
dockerpath="agostonp/udproj-kubernetes:uploaded"

# Step 2
# Run the Docker Hub container with kubernetes
#kubectl run udprojkubedemo --image="agostonp/udproj-kubernetes:uploaded" --port=8000 --generator="run-pod/v1"
kubectl run udprojkubedemo --image=$dockerpath --port=8000 --generator=run-pod/v1

# Step 3:
# List kubernetes pods
kubectl get pods

# Step 4:
# Forward the container port to a host
# Listen on port 8000 locally, forwarding to 80 in the pod
kubectl port-forward pod/udprojkubedemo 8000:80

