pipeline{
    agent any

    environment{
        APP_PORT = '3000'
    }

    stages{
        stage('Checkout'){
            steps{
                checkout scm
                script{
                    if (env.BRANCH_NAME == 'main'){
                        APP_PORT = '3000'
                    }else if (env.BRANCH_NAME == 'dev'){
                        APP_PORT = '3001'
                    }
                }
            }
        }

        stage('Build'){
            steps{
                echo 'Building the application...'
                sh 'chmod +x scripts/build.sh'
                sh './scripts/build.sh'
            }
        }

        stage('Test'){
            steps{
                echo 'Running tests...'
                sh 'chmod +x scripts/test.sh'
                sh './scripts/test.sh'

            }
        }

        stage('Build Docker Image'){
            steps{
                echo 'Building Docker image...'
                sh "docker build -t my-app:${env.BRANCH_NAME}-${env.BUILD_ID} ."
            }
        }

        stage('Deploy'){
            steps{
                echo "Deploying on port ${env.APP_PORT}..."
                sh """
                docker run -d -p ${env.APP_PORT}:${env.APP_PORT} --name my-app-${env.BRANCH_NAME} my-app:${env.BRANCH_NAME}-${env.BUILD_ID}
                """
                echo "Application deployed at http://localhost:${env.APP_PORT}"
            }
        }
    }
}

