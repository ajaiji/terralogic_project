pipeline {
    agent any  // Runs the pipeline on any available agent

    environment {
        DOCKER_CREDENTIALS_ID = 'dockerhub'  // Docker Hub credentials ID
        REPO_NAME = 'leohardin/terralogic'  // Your Docker Hub repository name
        PATH = "/usr/local/bin:$PATH"  // Adjust this path as needed for your system, ensure it includes Docker's binary location
        GIT_REPO = "https://github.com/ajaiji/terralogic_project.git"
        GIT_BRANCH = "main"
        GIT_CREDENTIALS = 'jenkins_git'  // Use the credentials ID for the PAT
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone your GitHub repository
                git branch: "${GIT_BRANCH}", url: "${GIT_REPO}", credentialsId: "${GIT_CREDENTIALS}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Get the current commit hash and branch name
                    def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def branchName = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()

                    // Build Docker image from the Dockerfile
                    def imageName = "${REPO_NAME}:${commitHash}-${branchName}"

                    // Docker build command
                    sh "docker build -t ${imageName} ."

                    // Tag the image with commit hash and branch name
                    currentBuild.description = "Building image: ${imageName}"
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub using Jenkins credentials
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        // Use docker login with --password-stdin to avoid passing password directly in the command
                        sh """
                            echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                        """
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the image to Docker Hub
                    def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                    def branchName = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()

                    def imageName = "${REPO_NAME}:${commitHash}-${branchName}"

                    sh "docker push ${imageName}"
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image successfully pushed to Docker Hub.'
        }
        failure {
            echo 'There was an error in the pipeline.'
        }
    }
}
