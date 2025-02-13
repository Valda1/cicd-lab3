pipeline {
    agent any

    environment {
        APP_PORT = '3000' // Default port
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    // Adjust APP_PORT based on the branch name
                    if (env.BRANCH_NAME == 'main') {
                        env.APP_PORT = '3000'
                    } else if (env.BRANCH_NAME == 'dev') {
                        env.APP_PORT = '3001'
                    }
                    // Log the port for verification
                    echo "APP_PORT set to ${env.APP_PORT}"
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
