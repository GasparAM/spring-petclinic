pipeline {
    agent any

    triggers {
        pollSCM '*/5 * * * *'
    }

    stages {
        stage('Docker up') {
            steps {
                sh '''
                    docker build -t "gavetisyangd/main:${GIT_COMMIT}" ./ 
                '''
            }
        }

        stage('Push') {
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
