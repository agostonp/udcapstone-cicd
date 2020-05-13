#!/usr/bin/env bash
# This file tags and uploads an image to Docker Hub

# Assumes that an image is built via `run_docker.sh`

# Step 1:
# Create dockerpath
dockerid="agostonp"
dockertag="udcapstone-cicd"
# dockerpath="agostonp/udcapstone-cicd"
dockerpath=`echo $dockerid"/"$dockertag`

# Step 2:  
# Authenticate & tag

# docker login --username=$dockerid #To be run only once

echo "Docker ID and Image: $dockerpath"
docker tag $dockertag $dockerpath
docker image ls $dockerpath

# Step 3:
# Push image to Docker Hub repository
docker push $dockerpath