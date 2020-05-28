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
        stage('Deploy for Production') {
            when {
                branch 'deployment'
            }
            steps {
                withAWS(region:'eu-central-1',credentials:'udcapstone-aws-credentials') {
                    echo "IMAGETAG provided: ${params.IMAGETAG}"
                    sh '''
                            # Add the new cluster to the kubeconfig file
                            aws eks --region "eu-central-1" update-kubeconfig --name UDCapstone

                            # Check that the Kubernetes cluster is up and running
                            kubectl get svc

                            # Check that our Kubernetes deployment is started
                            kubectl get deployment/$CONTAINERNAME

                            # Pods before update
                            kubectl get pods
                            kubectl describe pods | grep "Image:"


                            # Image to update to
                            echo IMAGETAG=$IMAGETAG

                            # Do rolling update
                            kubectl set image deployment/$CONTAINERNAME $CONTAINERNAME=$REPOPATH:$IMAGETAG

                            # See how the pods are replaced
                            for VARIABLE in 1 2 3 4 5
                            do
                                sleep 20
                                kubectl get pods
                                kubectl describe pods | grep "Image:"
                            done
                    '''
                }
            }
        }
    }
}
