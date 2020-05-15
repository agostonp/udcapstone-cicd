#!/usr/bin/env bash

sudo apt-get update -y

# install make
apt-get install -y make

# install tidy
sudo apt-get install -y tidy

# install hadolint
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.6/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint

# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# verify that kubectl is installed
kubectl version --short --client