#!/usr/bin/env bash
# WARNING! Do not run this file as is!
# This is more a collection of the steps to be done
exit

########################################################
## Create Jenkins instance
########################################################
cd infrastructure

# Create the public network elements
./cfcreate.sh udcapstone-pub-network ./public-network.yml ./network-params.json

# Create the Jenkins server
./cfcreate.sh udcapstone-jenkins ./jenkins-sevrer.yml ./environment-params.json

cd ..

########################################################
## Install needed software on running Jenkins server
########################################################

sudo apt-get update -y

# install make
apt-get install -y make

# install tidy
sudo apt-get install -y tidy

# install hadolint
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.6/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint



########################################################
### Probably NOT needed commands
########################################################
# get the latest version of aws - 1.18.49 is good enough
pip3 install awscli --upgrade --user

# Install aws-iam-authenticator
sudo curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
sudo chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/local/bin/
aws-iam-authenticator version

# install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# verify that kubectl is installed
kubectl version --short --client