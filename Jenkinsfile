pipeline {
    agent any

    triggers {
        pollSCM '*/5 * * * *'
    }

    stages {
        stage('Checkstyle') {
            when {
                expression {env.GIT_BRANCH != 'origin/main'}
            }
            steps {
                sh '''
                    ./mvnw checkstyle:checkstyle
                '''
            }
        }

        stage('Test') {
            when {
                expression {env.GIT_BRANCH != 'origin/main'}
            }
            steps {
                sh '''
                    ./mvnw test
                '''
            }
        }

        stage('Build') {
            when {
                expression {env.GIT_BRANCH != 'origin/main'}
            }
            steps {
                sh '''
                    ./mvnw clean package -Dmaven.test.skip=true
                '''
            }
        }

        stage('Docker up main') {
            when {
                expression {env.GIT_BRANCH == 'origin/main'}
            }
            steps {
                sh '''
                    docker build -t "gavetisyangd/main:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Docker up mr') {
            when {
                expression {env.GIT_BRANCH != 'origin/main'}
            }
            steps {
                sh '''
                    docker build -t "gavetisyangd/mr:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Push main') {
            when {
                expression {env.GIT_BRANCH == 'origin/main'}
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
                expression {env.GIT_BRANCH != 'origin/main'}
            }
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
