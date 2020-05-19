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
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-pub-network

# Create the Jenkins server
./cfcreate.sh udcapstone-jenkins ./jenkins-server.yml ./environment-params.json
# Wait until stack creation is complete
aws cloudformation wait stack-create-complete --stack-name udcapstone-jenkins

cd ..

########################################################
## Install needed software on running Jenkins server
########################################################
# 1. Modify the allowed IP address for SSH to your own IP in the SecurityGroup of the Jenkins server
# 2. Log in to the Jenkins server with ssh
ssh -i "..\Ago-Frankfurt-keypair.pem" ec2-user@ec2-18-195-8-96.eu-central-1.compute.amazonaws.com

# update all packages
sudo yum update –y

# install tidy
sudo yum install -y tidy
tidy --version

# install hadolint
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.17.6/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint
hadolint --version

# install git
sudo yum install -y git
git version

# install docker
sudo yum install -y docker
docker --version
sudo service docker start

# install kubectl
sudo curl -o /bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
sudo chmod +x /bin/kubectl
kubectl version --short --client

# install java 8
sudo yum install -y java-1.8.0
sudo yum remove -y java-1.7.0-openjdk
java -version

##### Download and install Jenkins, for details see: https://d1.awsstatic.com/Projects/P5505030/aws-project_Jenkins-build-server.pdf
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install jenkins -y
sudo service jenkins start

########################################################
### Configure Jenkins
########################################################
# 1. Connect to http://<your_server_public_DNS>:8080 from your favorite browser
# 2. Enter the password found in:
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# 3. Click Install suggested plugins
# 4. Enter Administrator Credentials,  click Save Credentials,  and then clickStart Using Jenkins
# 5. Instal plugins: Locale, Blue Ocean Aggregator, pipeline-aws
# 6. Create a global credential in Jenkins with kind="AWS Credentials"
# 7. Create a new pipeline in Blue Ocean, type=GitHub
# 8. Create access token in GitHub for Jenkins




########################################################
### Probably NOT needed commands
########################################################
# install tidy
# wget -O /tmp/libtidy.x86_64.rpm https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libtidy-5.4.0-1.el7.x86_64.rpm
# sudo rpm -Uvh /tmp/libtidy.x86_64.rpm
# wget -O /tmp/tidy.x86_64.rpm https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/t/tidy-5.4.0-1.el7.x86_64.rpm
# sudo rpm -Uvh /tmp/tidy.x86_64.rpm
# rm /tmp/libtidy.x86_64.rpm /tmp/tidy.x86_64.rpm

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