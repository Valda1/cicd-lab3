pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Environment') {
            steps {
                script {
                    // Initialize a local variable
                    def port
                    if (env.BRANCH_NAME == 'main') {
                        port = '3000'
                    } else if (env.BRANCH_NAME == 'dev') {
                        port = '3001'
                    } else {
                        port = '3000' // Default port
                    }

                    // Pass this variable to subsequent shell scripts as required
                    env.APP_PORT = port
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'chmod +x scripts/build.sh'
                sh './scripts/build.sh'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'chmod +x scripts/test.sh'
                sh './scripts/test.sh'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t my-app:${env.BRANCH_NAME}-${env.BUILD_ID} ."
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying on port ${env.APP_PORT}..."
                sh """
                docker run -d -p ${env.APP_PORT}:${env.APP_PORT} --name my-app-${env.BRANCH_NAME} my-app:${env.BRANCH_NAME}-${env.BUILD_ID}
                """
                echo "Application deployed at http://localhost:${env.APP_PORT}"
            }
        }
    }
}
