pipeline {
    agent { label 'JAVA' }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Git Checkout') {
            steps {
                git url: 'https://github.com/Sridevisiri2198/spring-petclinic.git', branch: 'main'
            }
        }

        stage('Java Build and Sonar Scan') {
            steps {
                script {
                    withSonarQubeEnv('SONAR') {
                        sh '''
                            mvn clean package sonar:sonar \
                              -Dsonar.host.url=https://sonarcloud.io \
                              -Dsonar.organization=sridevisiri2198 \
                              -Dsonar.projectName=spring-petclinic \
                              -Dsonar.projectKey=Sridevisiri2198_spring-petclinic
                        '''
                    }
                }
            }
        }

        stage('Upload to JFrog') {
            steps {
                script {
                    rtUpload (
                        serverId: 'JFROG_JAVA',
                        spec: '''{
                            "files": [
                                {
                                    "pattern": "target/*.jar",
                                    "target": "heavenrepo-libs-release/"
                                }
                            ]
                        }'''
                    )

                    rtPublishBuildInfo (
                        serverId: 'JFROG_JAVA'
                    )
                }
            }
        }

        stage('Docker image build') {
            steps {
                sh 'docker image build -t java:1.0 -f dockerfile .'
                sh 'docker image ls'
                sh 'docker tag java:1.0 699475951176.dkr.ecr.eu-north-1.amazonaws.com/javaprodimage:myjavaimage'
                sh 'docker push 699475951176.dkr.ecr.eu-north-1.amazonaws.com/javaprodimage:myjavaimage'
            }
        }
        stage('trivy image scan') {
            steps {
                sh 'trivy image 699475951176.dkr.ecr.eu-north-1.amazonaws.com/javaprodimage:myjavaimage'
                sh 'trivy image --format xml --output trivy-report.xml 699475951176.dkr.ecr.eu-north-1.amazonaws.com/javaprodimage:myjavaimage'

            }
        }

    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo '✅ This is a good pipeline'
        }
        failure {
            echo '❌ This is a failed pipeline'
        }
    }
}
