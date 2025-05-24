pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        ARTIFACTORY = 'JFrog'
        S3_BUCKET = 'cicd-s3-bucket-code-deploy'
        S3_KEY = 'spring-boot-hello-world.zip'
        AWS_REGION = 'ca-central-1'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/snehabopche/spring-boot-hello-world.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Upload to Artifactory') {
            steps {
                sh 'jfrog rt u "target/*.jar" libs-release-local/springboot-hello-world/'
            }
        }

        stage('Download from Artifactory') {
            steps {
                sh 'jfrog rt dl "libs-release-local/springboot-hello-world/*.jar" --flat'
            }
        }

        stage('Package for CodeDeploy') {
            steps {
                sh '''
                    mkdir -p codedeploy/scripts
                    cp *.jar codedeploy/app.jar
                    cp appspec codedeploy/appspec.yml
                    cp scripts/*.sh codedeploy/scripts/
                    chmod +x codedeploy/scripts/*.sh
                    cd codedeploy && zip -r ../$S3_KEY .
                '''
            }
        }

        stage('Upload to S3') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Credentials']]) {
                    sh '''
                        aws s3 cp $S3_KEY s3://$S3_BUCKET/$S3_KEY --region $AWS_REGION
                    '''
                }
            }
        }

        stage('Deploy with CodeDeploy') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'AWS_Credentials']]) {
                    sh '''
                        aws deploy create-deployment \
                          --application-name MyApp \
                          --deployment-group-name MyDeploymentGroup \
                          --s3-location bucket=$S3_BUCKET,bundleType=zip,key=$S3_KEY \
                          --region $AWS_REGION
                    '''
                }
            }
        }
    }
}

