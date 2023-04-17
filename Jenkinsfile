pipeline {
    agent any

    triggers {
        pollSCM '*/5 * * * *'
    }

    stages {
        stage('Checkstyle') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                sh '''
                    ./mvnw checkstyle:checkstyle
                '''
            }
        }

        stage('Test') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                sh '''
                    ./mvnw test
                '''
            }
        }

        stage('Build') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                sh '''
                    ./mvnw clean package -Dmaven.test.skip=true
                '''
            }
        }

        stage('Docker up') {
            steps {
                sh '''
                    docker build -t "gavetisyangd/mr:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Push') {
            steps {
                withCredentials([string(credentialsId: 'dhub', variable: 'TOKEN')]) {
                    sh '''
                        echo $TOKEN | docker login -u gavetisyangd --password-stdin
                        docker push "gavetisyangd/mr:${GIT_COMMIT}"
                    '''
                }
            }
        }
    }
}
