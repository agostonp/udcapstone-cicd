# udcapstone-cicd - CI/CD pipeline with Jenkins, Docker and Kubernetes

### Udacity Could DevOps Nanodgree Capstone project
### Author: Agoston Pajzs

## Project Overview

In this project, I demonstrate the skills I have acquired during the Udacity Cloud DevOps Nanodegree:
Set up a Continuous Integration and a Continuous Deployment pipeline in Jenkins.

As an example application I am using a static website deployed in nginx.
The application is built by Jenkins, packed as a Docker container, uploaded to an Amazon ECR container repository and then deployed into a high availability Amazon EKS Kubernetes cluster.
The infrastructure is set up from scripts using CloudFormation template files for the VPC, public and private subnets, the Jenkins server (EC2 instance), the container repository and the Kubernetes cluster.
The entire infrastructure can be recreated from zero using the scripts and instructions in this GitHub repo in less than 60 minutes.
The application built and deployed could be extended without major changes in the integration and deployment framework.

### Project Tasks

The project goal was to operationalize this working, machine learning microservice using [kubernetes](https://kubernetes.io/), which is an open-source system for automating the management of containerized applications.
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