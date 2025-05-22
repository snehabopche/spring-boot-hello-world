pipeline {
    agent any

    tools {
        maven 'Maven3' // Must match the name in Jenkins Global Tool Configuration
        jdk 'JDK17'    // Must match the name in Jenkins Global Tool Configuration
    }

    environment {
        SONARQUBE = 'SonarQube'       // Name in Jenkins SonarQube configuration
        ARTIFACTORY = 'JFrog'         // Server ID of JFrog Artifactory in Jenkins
        S3_BUCKET = 'cicd-s3-bucket-code-deploy' // Your actual S3 bucket name
        S3_KEY = 'spring-boot-hello-world.zip'
        AWS_REGION = 'ca-central-1'   // AWS region
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
                rtUpload(
                    serverId: "${ARTIFACTORY}",
                    spec: """{
                        "files": [{
                            "pattern": "target/*.jar",
                            "target": "libs-release-local/springboot-hello-world/"
                        }]
                    }"""
                )
            }
        }

        stage('Package for CodeDeploy') {
            steps {
                sh '''
                    mkdir -p codedeploy
                    cp target/*.jar codedeploy/
                    cp -r scripts codedeploy/
                    cp appspec.yml codedeploy/
                    cd codedeploy && zip -r ../${S3_KEY} .
                '''
            }
        }

        stage('Upload to S3') {
            steps {
                sh 'aws s3 cp ${S3_KEY} s3://${S3_BUCKET}/${S3_KEY} --region ${AWS_REGION}'
            }
        }

        stage('Deploy to EC2 with CodeDeploy') {
            steps {
                sh '''
                    aws deploy create-deployment \
                    --application-name MyApp \
                    --deployment-group-name MyDeploymentGroup \
                    --s3-location bucket=${S3_BUCKET},bundleType=zip,key=${S3_KEY} \
                    --region ${AWS_REGION}
                '''
            }
        }
    }
}

