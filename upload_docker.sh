#!/usr/bin/env bash
# This file tags and uploads an image to Amazon ECR

############################################
## Create new repository in Amazon ECR
############################################
cd infrastructure

# Create the repository in Amazon ECR
./cfcreate.bat udcapstone-ecr-repo ./ecr-repo.yml ./ecr-repo-params.json
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-ecr-repo

cd ..


############################################
## Push image to Amazon ECR
############################################

# Create dockerpath
dockerimage=udcapstone-cicd
repopath=857339242870.dkr.ecr.eu-central-1.amazonaws.com/$dockerimage
echo "Repo path and Docker Image: $repopath"

# Authenticate Docker to my Amazon ECR registry
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $repopath

# Tag image with teh repopath
docker tag $dockerimage:latest $repopath:latest
docker image ls $repopath

# Push image to Amazon ECR repository
docker push $repopath:latest
