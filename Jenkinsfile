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

        stage('Docker up main') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    docker build -t "gavetisyangd/main:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Docker up mr') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                sh '''
                    docker build -t "gavetisyangd/main:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Push main') {
            when {
                branch 'main'
            }
            steps {
                withCredentials([string(credentialsId: 'dhub', variable: 'TOKEN')]) {
                    sh '''
                        echo $TOKEN | docker login -u gavetisyangd --password-stdin
                        docker push "gavetisyangd/main:${GIT_COMMIT}"
                    '''
                }
            }
        }

        stage('Push mr') {
            when {
                not {
                    branch 'main'
                }
            }
            steps {
                withCredentials([string(credentialsId: 'dhub', variable: 'TOKEN')]) {
                    sh '''
                        echo $TOKEN | docker login -u gavetisyangd --password-stdin
                        docker push "gavetisyangd/main:${GIT_COMMIT}"
                    '''
                }
            }
        }
    }
}
