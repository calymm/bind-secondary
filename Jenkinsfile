pipeline {
    agent { label 'podman' }
    triggers { pollSCM('H/2 * * * *') }
    environment {
        REGISTRY = 'registry.assign.cmacleod8.300.ops:5000'
        IMAGE    = "${REGISTRY}/bind-secondary"
    }
    stages {
        stage('Build') {
            steps {
                sh 'podman build -t "$IMAGE:$BUILD_NUMBER" .'
            }
        }
        stage('Scan') {
            steps {
                sh '''
                    podman save --format docker-archive -o "scan-$BUILD_NUMBER.tar" "$IMAGE:$BUILD_NUMBER"
                    trivy image --input "scan-$BUILD_NUMBER.tar" --severity HIGH,CRITICAL --exit-code 1 --no-progress
                '''
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'registry-login',
                                 usernameVariable: 'REG_USER',
                                 passwordVariable: 'REG_PASS')]) {
                    sh '''
                        echo "$REG_PASS" | podman login "$REGISTRY" -u "$REG_USER" --password-stdin
                        podman push "$IMAGE:$BUILD_NUMBER"
                        podman logout "$REGISTRY"
                    '''
                }
            }
        }
    }
    post {
        always {
            sh 'rm -f scan-*.tar'
        }
    }
}
