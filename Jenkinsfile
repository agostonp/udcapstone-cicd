pipeline {
    agent any

    parameters {
        string(name: 'IMAGETAG', defaultValue: 'latest', description: 'Which image should be deployed? Enter image tag:')
    }

    environment {
        DOCKERIMAGE = "udcapstone-cicd"
        REPOPATH = "857339242870.dkr.ecr.eu-central-1.amazonaws.com/${env.DOCKERIMAGE}"
        CONTAINERNAME="udcapstonedemo"
    }

    stages {
        stage("Env Variables") {
            steps {
                sh "printenv"
            }
        }
        stage('Lint') {
            when {
                branch 'master'
            }
            steps {
                sh 'tidy -q -e www/*.html'
                sh 'hadolint Dockerfile'
            }
        }
//         stage('Security Scan') {
//              steps { 
//                 aquaMicroscanner imageName: 'alpine:latest', notCompleted: 'exit 1', onDisallowed: 'fail'
//              }
//         }         
        stage('Build Docker image') {
            when {
                branch 'master'
            }
            steps {
                // Build docker image and add a descriptive tag
                sh 'docker build --tag=$DOCKERIMAGE .'

                //List docker images
                sh 'docker image ls $DOCKERIMAGE'
            }
        }
        stage('Upload to Amazon ECR') {
            when {
                branch 'master'
            }
            steps {
                withAWS(region:'eu-central-1',credentials:'udcapstone-aws-credentials') {
                    sh '''
                            # Create dockerpath
                            #dockerimage=udcapstone-cicd
                            #repopath=857339242870.dkr.ecr.eu-central-1.amazonaws.com/$dockerimage
                            echo "Repo path and Docker Image: $REPOPATH"

                            # Authenticate Docker to my Amazon ECR registry
                            aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin $REPOPATH

                            # Tag image with teh repopath
                            docker tag $DOCKERIMAGE:latest $REPOPATH:$BUILD_TAG
                            docker image ls $REPOPATH

                            # Push image to Amazon ECR repository
                            docker push $REPOPATH:$BUILD_TAG
                    '''
                }
            }
        }
        stage('Deploy for Production') {
            when {
                branch 'deployment'
            }
            steps {
                withAWS(region:'eu-central-1',credentials:'udcapstone-aws-credentials') {
                    sh '''
                            # Add the new cluster to the kubeconfig file
                            aws eks --region "eu-central-1" update-kubeconfig --name UDCapstone

                            # Check that the Kubernetes cluster is up and running
                            kubectl get svc

                            # Check that our Kubernetes deployment is started
                            kubectl get deployment/$CONTAINERNAME

                            # Image to update to
                            echo IMAGETAG=$IMAGETAG

                            # Do rolling update
                            kubectl set image deployment/$CONTAINERNAME $CONTAINERNAME=$REPOPATH:$IMAGETAG

                            # See how the pods are replaced
                            for VARIABLE in 1 2 3 4 5
                            do
                                sleep 2
                                kubectl get pods
                            done
                    '''
                }
            }
        }
    }
}
