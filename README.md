# CI/CD pipeline with Jenkins, Docker and Kubernetes (udcapstone-cicd)

#### Udacity Could DevOps Nanodgree Capstone project
#### Author: Agoston Pajzs

## Project Overview

In this project, I demonstrate the skills I have acquired during the Udacity Cloud DevOps Nanodegree:
Set up a Continuous Integration and a Continuous Deployment pipeline in Jenkins.

As an example application I am using a static website deployed in nginx.
The application is built by Jenkins, packed as a Docker container, uploaded to an Amazon ECR container repository and then deployed into a high availability Amazon EKS Kubernetes cluster.
The infrastructure is set up from scripts using CloudFormation template files for the VPC, public and private subnets, the Jenkins server (EC2 instance), the container repository and the Kubernetes cluster.
**The entire infrastructure can be recreated from zero using the scripts and instructions in this GitHub repo in less than 60 minutes.**
The application built and deployed could be extended without major changes in the integration and deployment framework.

## Technology Used

The followings are demonstrated as part of the solution:

* **Host a static web application** - The sample application is a minimalist static webpage that consists of two files [www/index.html](https://github.com/agostonp/udcapstone-cicd/blob/master/www/index.html) and [images\Kyrenia_harbor.jpg](https://github.com/agostonp/udcapstone-cicd/blob/master/images/Kyrenia_harbor.jpg). The application could be extended without major changes in the CI/CD framework and the framework would still be functional.

* **[nginx](https://nginx.org/en/docs/) web server** used as a Docker image, I configured it in [nginx/nginx.conf](https://github.com/agostonp/udcapstone-cicd/blob/master/nginx/nginx.conf)

* **[Docker](https://docs.docker.com/) container** - I built my own Docker image on top of the nginx official image using a [Dockerfile](https://github.com/agostonp/udcapstone-cicd/blob/master/Dockerfile) and commands of the docker cli as shown in [run_docker.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/run_docker.sh)

* **[AWS - Amazon Web Services](https://aws.amazon.com)** - The entire solution runs in the Amazon cloud, including the networking ([Amazon VPC](https://aws.amazon.com/vpc/)) the Jenkins server ([EC2 instance](https://aws.amazon.com/ec2/)), the Docker container registry ([Amazon ECR](https://aws.amazon.com/ecr/)) and the Kubernetes service ([Amazon EKS](https://aws.amazon.com/eks/))

* **Infrastucture as Code using [AWS CloudFormation](https://aws.amazon.com/cloudformation/)** - The entire infrastructure is defined in CloudFormation template files - i.e. as scripts and it can be recreated from scratch on an empty AWS account. See the [infrastructure folder](https://github.com/agostonp/udcapstone-cicd/tree/master/infrastructure):
    * **Networking** The scripts  [private-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/private-network.yml) and [public-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/public-network.yml) create all network elements: VPC, public and private subnets, gateways. This network is used by both the build server and the production environment
    * **Access Management** The script [iam.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/iam.yml) creates the [IAM](https://aws.amazon.com/iam/) roles needed to use the Kubernetes cluster
    * **Jenkins server** The script [jenkins-server.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/jenkins-server.yml) creates the server instance and installs all required software automatically. It also defines an Elastic IP (to make IP fixed) and SecurityGroup (to block unwanted access)
    * **Container repository** The script [ecr-repo.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/ecr-repo.yml) creates the Amazon Elastic Container Repository to store the Dokcer images of the sample application and also governs access with a repositry policy
    * **Kubernetes cluster** The script [kubecluster.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/kubecluster.yml) creates the "production" Kubernetes cluster, its worker node group and required security groups

* **Deploy a container in Kubernetes** I configured and used kubectl command line tool to deploy my Docker containerized sample application in a Kubernetes cluster. Commands can be found in [run_kubernetes.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/run_kubernetes.sh), section 'Initial Deployment'. I used a Kubernetes manifest file ([kube-deployment.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/kube-deployment.yml)) and the uploaded Docker image of the application.
(The manifest file was needed only to change the rollingUpdate parameters. Otherwise a kubectl create command would have been enough.)
I used Amazon's Docker container registry ([Amazon ECR](https://aws.amazon.com/ecr/)) and Kubernetes service ([Amazon EKS](https://aws.amazon.com/eks/))

* **Install and configure a Jenkins server** The [install_jenkins.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/install_jenkins.sh) script contains the steps to automatically provision an EC2 instance and install Jenkins and all required other software on the new server.
The script also contains the manual steps needed to configure Jenkins after it is installed.
The EC2 runs Amazon Linux, the script installs: tidy, hadolint, git, docker cli, kubectl cli, Java 8 and Jenkins

* **Jenkins pipeline** - I created two declarative Jenkins multibranch pipelines defined as Jenkinsfiles and used Blue Ocean to run and monitor them. I use GitHub-Jenkins integration to automatically rebuild when new code is checked in to the GitHub repo. Two branches are used in GitHub to separate the two pipelines:
    * **Continuous Integration pipeline** -  [Jenkinsfile, on master branch](https://github.com/agostonp/udcapstone-cicd/blob/master/Jenkinsfile) tests the code with linting, builds a docker image and uploads it to the container repository
    * **Continuous Deployment pipeline** -  [Jenkinsfile, on deployment branch](https://github.com/agostonp/udcapstone-cicd/blob/deployment/Jenkinsfile) deploys the new releases to the "production" Kubernetes cluster. In practice it deploys the Docker image that was uploaded to the container repository by the other pipeline

* **Rolling Update / Rolling Deployment** is used to deploy the new releases to "production" with **zero downtime**. This is implemented by the [Kubernetes Rolling Update feature] (https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/) (`kubectl set image` command), see [Jenkinsfile, on deployment branch](https://github.com/agostonp/udcapstone-cicd/blob/deployment/Jenkinsfile)

* **Git and GitHub** was used to provide version control during the development of this solution


---

## How to use?

### Prerequisites
aws account
aws cli configured - can be in a Cloud9 environment inside AWS
GitHub account
git configured

### Preparation - have your own copy!
Clone the GitHub repo - to have your own copy of it in GitHub - not enough to clone with git, as Jenkins needs the GitHub repo.
Replace AWS account id in all files from 857339242870 to your own account id

### Set up the infrastructure

### Running the build in Jenkins

### Deploy to production using Jenkins

### Access the deployed web application

