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
                    withSonarQubeEnv('SONARQUBE') {
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

        stage('Upload JAR to JFrog') {
            steps {
                script {
                    rtUpload(
                        serverId: 'JFROG',
                        spec: '''{
                            "files": [
                                {
                                    "pattern": "target/*.jar",
                                    "target": "practicerepo-libs-release/"
                                }
                            ]
                        }'''
                    )

                    rtPublishBuildInfo(
                        serverId: 'JFROG'
                    )
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Authenticate Docker to JFrog using Jenkins credentials
                withCredentials([usernamePassword(
                    credentialsId: 'myjfrogidentity_token', 
                    usernameVariable: 'JFROG_USER', 
                    passwordVariable: 'JFROG_PASS'
                )]) {
                    sh '''
                        curl -u $JFROG_USER:$JFROG_PASS -O https://trialp1bjia.jfrog.io/artifactory/practicerepo-libs-release/spring-petclinic-3.5.0-SNAPSHOT.jar
                        docker build -t java:1.1 -f dockerfile .
                        docker tag java:1.1 699475951176.dkr.ecr.eu-north-1.amazonaws.com/springpetrepository:App3
                        docker push 699475951176.dkr.ecr.eu-north-1.amazonaws.com/springpetrepository:App3
                    '''
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
