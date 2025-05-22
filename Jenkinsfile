pipeline { 
    agent any

    tools {
        maven 'Maven3' // Defined in Jenkins Global Tool Config
        jdk 'JDK17'    // Defined in Jenkins Global Tool Config
    }

    environment {
        SONARQUBE = 'SonarQube'         // Name in Jenkins SonarQube config
        ARTIFACTORY = 'JFrog'           // Name of JFrog server in Jenkins
        S3_BUCKET = 'cicd-s3-bucket-code-deploy'      // Replace with your actual bucket name
        S3_KEY = 'spring-boot-hello-world.zip'
        AWS_REGION = 'ca-central-1'        // Replace with your AWS region
    }
stage('Clone') {
    steps {
        git branch: 'main', url: 'https://github.com/snehabopche/spring-boot-hello-world.git'
    }
}


   
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE}") {
                    sh 'mvn clean verify sonar:sonar'
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

