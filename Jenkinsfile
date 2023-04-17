pipeline {
    agent any

    triggers {
        pollSCM '*/5 * * * *'
    }

    stages {
        stage('Checkstyle') {
            when {
                not {
                    branch "*origin/main"
                }
            }
            steps {
                sh '''
                    echo "mvnw checkstyle:checkstyle"
                '''
            }
        }

        stage('Test') {
            when {
                not {
                    branch "*origin/main"
                }
            }
            steps {
                sh '''
                    echo "mvnw test"
                '''
            }
        }

        stage('Build') {
            when {
                not {
                    branch "*origin/main"
                }
            }
            steps {
                sh '''
                    echo "mvnw clean package -Dmaven.test.skip=true"
                '''
            }
        }

        stage('Docker up main') {
            when {
                branch "*origin/main"
            }
            steps {
                sh '''
                    echo "docker build -t "gavetisyangd/main:${GIT_COMMIT}" ./ "
                '''
            }
        }

        stage('Docker up mr') {
            when {
                not {
                    branch "*origin/main"
                }
            }
            steps {
                sh '''
                    echo "docker build -t "gavetisyangd/mr:${GIT_COMMIT}" ./ "
                '''
            }
        }

        stage('Push main') {
            when {
                branch "*origin/main"
            }
            steps {
                withCredentials([string(credentialsId: 'dhub', variable: 'TOKEN')]) {
                    sh '''
                        echo $TOKEN | docker login -u gavetisyangd --password-stdin
                        echo "docker push "gavetisyangd/main:${GIT_COMMIT}""
                    '''
                }
            }
        }

        stage('Push mr') {
            when {
                not {
                    branch "*origin/main"
                }
            }
            steps {
                withCredentials([string(credentialsId: 'dhub', variable: 'TOKEN')]) {
                    sh '''
                        echo $TOKEN | docker login -u gavetisyangd --password-stdin
                        echo "docker push "gavetisyangd/mr:${GIT_COMMIT}""
                    '''
                }
            }
        }
    }
}
