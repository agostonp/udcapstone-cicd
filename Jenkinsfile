pipeline {
    agent any

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
    }
}
