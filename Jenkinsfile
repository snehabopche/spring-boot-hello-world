pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'JDK17'
    }

    environment {
        SONARQUBE = 'SonarQube'       // Jenkins SonarQube config name
        ARTIFACTORY = 'JFrog'         // Jenkins Artifactory server ID
        S3_BUCKET = 'cicd-s3-bucket-code-deploy'
        S3_KEY = 'spring-boot-hello-world.zip'
        AWS_REGION = 'ca-central-1'
    }

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/snehabopche/spring-boot-hello-world.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                        sh 'mvn clean verify sonar:sonar -Dsonar.token=$SONAR_TOKEN'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh 'mvn package -DskipTests'
            }
        }

        stage('Publish to Artifactory') {
            steps {
                script {
                    def server = Artifactory.server("${ARTIFACTORY}")
                    def uploadSpec = """{
                        "files": [{
                            "pattern": "target/*.jar",
                            "target": "libs-release-local/springboot-hello-world/"
                        }]
                    }"""
                    server.upload(uploadSpec)
                }
            }
        }

        stage('Package for CodeDeploy') {
            steps {
                sh '''
                    mkdir -p codedeploy
                    cp target/*.jar codedeploy/app.jar
                    cp -r scripts codedeploy/
                    cp appspec.yml codedeploy/
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

        stage('Deploy to EC2 with CodeDeploy') {
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

