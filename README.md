# udcapstone-cicd - CI/CD pipeline with Jenkins, Docker and Kubernetes

### Udacity Could DevOps Nanodgree Capstone project
### Author: Agoston Pajzs

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
* **[nginx](https://nginx.org/en/docs/) web server** used as a docker image, I configured it in [nginx\nginx.conf](https://github.com/agostonp/udcapstone-cicd/blob/master/nginx/nginx.conf)
* **[Docker](https://docs.docker.com/) container** I built my own Docker image on top of the nginx official image using a [Dockerfile](https://github.com/agostonp/udcapstone-cicd/blob/master/Dockerfile) and commands of the docker cli as shown in [run_docker.sh](https://github.com/agostonp/udcapstone-cicd/blob/master/run_docker.sh)
* **[AWS - Amazon Web Services](https://aws.amazon.com)** The entire solution runs in the Amazon cloud, including the networking ([Amazon VPC](https://aws.amazon.com/vpc/)) the Jenkins server ([EC2 instance](https://aws.amazon.com/ec2/)), the Docker container registry ([Amazon ECR](https://aws.amazon.com/ecr/)) and the Kubernetes service ([Amazon EKS](https://aws.amazon.com/eks/))
* **Infrastucture as Code using [AWS CloudFormation](https://aws.amazon.com/cloudformation/)** The entire infrastructure is defined in CloudFormation template files - i.e. as scripts and it can be recreated from scratch on an empty AWS account. See the [infrastructure folder](https://github.com/agostonp/udcapstone-cicd/tree/master/infrastructure).
    * **Networking** The scripts  [private-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/private-network.yml) and [public-network.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/public-network.yml) create all network elements: VPC, public and private subnets, gateways. This network is used by both the build server and the production environment.
    * **Jenkins server** The script [jenkins-server.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/jenkins-server.yml) creates the server instance and installs all required software automatically. It also defines an Elastic IP (to make IP fixed) and SecurityGroup (to block unwanted access)
    * **Container repository** The script [ecr-repo.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/ecr-repo.yml) creates the Amazon Elastic Container Repository to store the Dokcer images of the sample application and also governs access with a repositry policy
    * **Kubernetes cluster** The script [kubecluster.yml](https://github.com/agostonp/udcapstone-cicd/blob/master/infrastructure/kubecluster.yml) creates the "production" Kubernetes cluster, its worker node group and required security groups

TODO:
* **Install and configure a Jenkins server** runs on Amazon Linux, installed components, configuration steps...
* **Git and GitHub**



The following tasks were performed:
* Test project code using linting
* Complete a Dockerfile to containerize this application
* Deploy containerized application using Docker and make a prediction
* Improve the log statements in the source code for this application
* Configure Kubernetes and create a Kubernetes cluster
* Deploy a container using Kubernetes and make a prediction
* Upload a complete Github repo with CircleCI to indicate that the code has been tested


---

## Setup the Environment

* Create a virtualenv and activate it
* Run `make install` to install the necessary dependencies

### Running `app.py`

1. Standalone:  `python app.py`
2. Run in Docker:  `./run_docker.sh`
3. Upload to Docker Hub: `./upload_docker.sh`
4. Run in Kubernetes:  `./run_kubernetes.sh`
5. Simple client to test the perdiction service: `./make_prediction.sh`

### Kubernetes Steps

* Setup and Configure Docker locally
* Setup and Configure Kubernetes locally
* Create Flask app in Container
* Run via kubectl

### Other files in the repository

* .circleci/config.yml: build configuration for the cloud native continuous integration tool that is used for the validation of the project code
* model_data directory: `sklearn` model that has been trained to predict housing prices in Boston
* output_txt_files directory: sample out logs from a docker and a kubernetes run
* app.py: the main script containing the boilerplate code to execute the predictions in the model