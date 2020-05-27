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

## Technology

The followings are demonstrated as part of the solution:

* **Host a static web application**  
The sample application is a minimalist static webpage that consists of two files [www/index.html](https://github.com/agostonp/udcapstone-cicd/blob/master/www/index.html) and [images/Kyrenia_harbor.jpg](https://github.com/agostonp/udcapstone-cicd/blob/master/images/Kyrenia_harbor.jpg).  
The application could be extended without major changes in the CI/CD framework and the framework would still be functional

* **[nginx](https://nginx.org/en/docs/) web server**  
Nginx was used as a Docker image, I configured it in [nginx/nginx.conf](https://github.com/agostonp/udcapstone-cicd/blob/master/nginx/nginx.conf)

* **[Docker](https://docs.docker.com/) container**  
I built my own Docker image on top of the nginx official image using a [Dockerfile](https://github.com/agostonp/udcapstone-cicd/blob/master/Dockerfile) and commands of the docker cli as shown in [run_docker.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/run_docker.sh)

* **[AWS - Amazon Web Services](https://aws.amazon.com)**  
The entire solution runs in the Amazon cloud, including the networking ([Amazon VPC](https://aws.amazon.com/vpc/)) the Jenkins server ([EC2 instance](https://aws.amazon.com/ec2/)), the Docker container registry ([Amazon ECR](https://aws.amazon.com/ecr/)) and the Kubernetes service ([Amazon EKS](https://aws.amazon.com/eks/))

* **Infrastucture as Code using [AWS CloudFormation](https://aws.amazon.com/cloudformation/)**  
The entire infrastructure is defined in CloudFormation template files - i.e. as scripts and it can be recreated from scratch on an empty AWS account. See the [infrastructure folder](https://github.com/agostonp/udcapstone-cicd/tree/master/infrastructure):  
    * **Networking**  
    The scripts  [private-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/private-network.yml) and [public-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/public-network.yml) create all network elements: VPC, public and private subnets, gateways. This network is used by both the build server and the production environment  
    * **Access Management**  
    The script [iam.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/iam.yml) creates the [IAM](https://aws.amazon.com/iam/) roles needed to use the Kubernetes cluster  
    * **Jenkins server**  
    The script [jenkins-server.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/jenkins-server.yml) creates the server instance and installs all required software automatically. It also defines an Elastic IP (to make IP fixed) and SecurityGroup (to block unwanted access)  
    * **Container repository**  
    The script [ecr-repo.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/ecr-repo.yml) creates the Amazon Elastic Container Repository to store the Dokcer images of the sample application and also governs access with a repositry policy  
    * **Kubernetes cluster**  
    The script [kubecluster.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/kubecluster.yml) creates the "production" Kubernetes cluster, its worker node group and required security groups

* **Deploy a container in Kubernetes**  
I configured and used kubectl command line tool to deploy my Docker containerized sample application in a Kubernetes cluster. Commands can be found in [run_kubernetes.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/run_kubernetes.sh), section 'Initial Deployment'.  
I used a Kubernetes manifest file ([kube-deployment.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/kube-deployment.yml)) and the uploaded Docker image of the application.  
(The manifest file was needed only to change the rollingUpdate parameters. Otherwise a kubectl create command would have been enough.)  
I used Amazon's Docker container registry ([Amazon ECR](https://aws.amazon.com/ecr/)) and Kubernetes service ([Amazon EKS](https://aws.amazon.com/eks/))

* **Install and configure a Jenkins server**  
The [install_jenkins.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/install_jenkins.sh) script contains the steps to automatically provision an EC2 instance and install Jenkins and all required other software on the new server.
The script also contains the manual steps needed to configure Jenkins after it is installed.
The EC2 runs Amazon Linux, the script installs: tidy, hadolint, git, docker cli, kubectl cli, Java 8 and Jenkins

* **Jenkins pipeline**  
I created two declarative Jenkins multibranch pipelines defined as Jenkinsfiles and used Blue Ocean to run and monitor them. I used GitHub-Jenkins integration to automatically rebuild when new code is checked in to the GitHub repo. Two branches are used in GitHub to separate the two pipelines:  
    * **Continuous Integration pipeline**  
    The [Jenkinsfile, on master branch](https://github.com/agostonp/udcapstone-cicd/blob/master/Jenkinsfile) tests the code with linting, builds a docker image and uploads it to the container repository  
    * **Continuous Deployment pipeline**  
    The [Jenkinsfile, on deployment branch](https://github.com/agostonp/udcapstone-cicd/blob/deployment/Jenkinsfile) deploys the new releases to the "production" Kubernetes cluster. In practice it deploys the Docker image that was uploaded to the container repository by the other pipeline

* **Rolling Update / Rolling Deployment**  
Rolling Deployment is used to deploy the new releases to "production" with **zero downtime**. This is implemented by the [Kubernetes Rolling Update feature](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/) (`kubectl set image` command), see [Jenkinsfile, on deployment branch](https://github.com/agostonp/udcapstone-cicd/blob/deployment/Jenkinsfile)

* **Git and GitHub**  
Git and GitHub was used to provide version control during the development


---

## How to use?

### Prerequisites

* Have your own [AWS Account](https://portal.aws.amazon.com/billing/signup)
* Install and Configure [aws-cli](https://aws.amazon.com/cli/) on your client computer (or you can use an [AWS Cloud9](https://aws.amazon.com/cloud9/) environment)
* Have your own [GitHub account](https://github.com/join)
* Install and Configure [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) on your client computer (or you can use an [AWS Cloud9](https://aws.amazon.com/cloud9/) environment)
* Understand how to use [git](https://www.udacity.com/course/version-control-with-git--ud123) and [GitHub](https://guides.github.com/activities/hello-world/)

### Preparation - have your own copy!

* Clone this [GitHub repo](https://github.com/agostonp/udcapstone-cicd) to have your own copy of it in GitHub. It is not enough to clone to local folder with git, as Jenkins needs the GitHub repo
* Replace AWS Account id in all files (in your own GitHub repo) from 857339242870 to your own AWS Account id

### Set up the infrastructure

#### 1. Install and Configure Jenkins

1. Run the commands in: `install_jenkins.sh`, section `Create Jenkins instance`  
NOTE: this also creates the public part of the network
2. Do the manual Jenkins configuration steps in `install_jenkins.sh`, section `Configure Jenkins`

#### 2. Create container repository in Amazon ECR 

Run the commands in: `upload_docker.sh`, section `Create new repository in Amazon ECR`  

#### 3. Upload the first Docker image in the container

Before clicking on the Jenkins build, I suggest to first test manually that everything works fine.  
This step is also useful to have a first image uploaded, so you can do the initial deployment to Kubernetes.

Do the followings in a terminal on the Jenkins server:
1. Build the image: run the commands in `run_docker.sh`
2. Check the page from your browser  
If all went well and your SecurityGroups allow the server to be accessible from outside through port 80, you should be able to see the index.html from the browser of your computer. In the browser, use the `Public DNS (IPv4)` of your EC2 instance as address.
3. Upload the image: run the commands in `upload_docker.sh`, section `Push image to Amazon ECR`  

#### 4. Create the Kubernetes Cluster and worker node group

Run the commands in: `run_kubernetes.sh`, section `Create Kubernetes Cluster in Amazon EKS`  
NOTE: This takes more than 15 minutes to complete.

#### 5. Deploy the first container in the Kubernetes Cluster

1. Run the commands in: `run_kubernetes.sh`, section `Initial Deployment`  
2. At this point you should be able to see the webpage running in the "production" environment. Follow steps in `Access the deployed web application` below.

### Running the build in Jenkins

### Deploy an update to production using Jenkins

### Access the deployed web application

