pipeline {
    agent any
    stages {
        stage('Lint') {
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
        stage('Build Docker container') {
            when {
                branch 'master'
            }
            steps {
                // Build docker image and add a descriptive tag
                sh 'docker build --tag="udcapstone-cicd" .'

                //List docker images
                sh 'docker image ls udcapstone-cicd'
            }
        }
        stage('Upload to DockerHub') {
            when {
                branch 'master'
            }
            steps {
                sh 'echo "Upload to DockerHub or Amazon ECR steps come here"'
                // withAWS(region:'eu-central-1',credentials:'udcapstone-aws-credentials') {
                //     sh 'echo "Uploading content with AWS creds"'
                //     s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'index.html', bucket:'ago-jenkins-pipeline')
                // }
            }
        }
        stage('Deploy for Production') {
            when {
                branch 'deployment'
            }
            steps {
                 sh 'echo "Deploy for production steps come here"'
            }
        }
    }
}
