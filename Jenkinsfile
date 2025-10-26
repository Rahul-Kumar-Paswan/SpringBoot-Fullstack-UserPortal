pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    environment {
        AWS_REGION              = "ap-south-1"
        APP_NAME                = "userportal-app"
        PROJECT_NAME            = "springboot-fullstack-userportal"
        DOCKER_REGISTRY         = "rahulkumarpaswan"
        BUILD_VERSION           = "v1.${BUILD_NUMBER}"
        DOCKER_IMAGE            = "${DOCKER_REGISTRY}/${APP_NAME}:${BUILD_VERSION}"
        K8S_CLUSTER_NAME        = "SpringBoot-eks-cluster"
        NAMESPACE               = "prod"
        SLACK_CHANNEL           = "#jenkins-notification"
        SCANNER_HOME            = tool 'sonar-scanner'
        SONAR_PROJECT_KEY       = "userportal-app"
        SONAR_PROJECT_NAME      = "UserPortal - Spring Boot Application"
        MYSQL_DB_NAME           = "userportal_db"
    }

    stages {
        stage("Cleanup Workspace"){
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-token', url: 'https://github.com/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal.git'
            }
        }

        stage('Code Compilation') {
            steps {
                echo "Building Java app"
                sh 'mvn clean compile -B -DskipTests'
            }
        }

        stage('Unit & Integration Tests') {
            steps {
                sh """
                    docker run -d --name mysql-test \
                    -e MYSQL_ROOT_PASSWORD=rootpass \
                    -e MYSQL_DATABASE=${MYSQL_DB_NAME} \
                    -e MYSQL_USER=appuser \
                    -e MYSQL_PASSWORD=apppass \
                    -p 3306:3306 mysql:8.0
                """
                sh """
                    echo "Waiting for MySQL to be ready..."
                    until docker exec mysql-test mysqladmin ping -h "localhost" --silent; do
                        sleep 2
                    done
                """
                sh """
                    mvn test -B \
                    -Dspring.datasource.url=jdbc:mysql://localhost:3306/${MYSQL_DB_NAME} \
                    -Dspring.datasource.username=appuser \
                    -Dspring.datasource.password=apppass
                """
            }
            post {
                always {
                    sh 'docker rm -f mysql-test || true'
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        stage('Security Scan - Gitleaks') {
            steps {
                sh 'gitleaks detect --source=. --report-format=json --report-path=gitleaks-report.json || true'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'gitleaks-report.json', allowEmptyArchive: true
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                        -Dsonar.projectName='${SONAR_PROJECT_NAME}' \
                        -Dsonar.java.binaries=target/classes
                    """
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Trivy FS Scan') {
            steps {
                sh """
                    trivy fs --format table -o fs-report.html --exit-code 1 --severity HIGH,CRITICAL .
                """
            }
        }

        stage('Build Artifact & Deploy to Nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'nexus-config', maven: 'maven3') {
                    sh 'mvn clean deploy -DskipTests'
                }
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-cred') {
                        sh """
                            docker build -t ${DOCKER_IMAGE} .
                            trivy image --format table -o trivy-image-report.html ${DOCKER_IMAGE}
                            docker push ${DOCKER_IMAGE}
                        """
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                dir('./k8s/') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                    ]) {
                        script {
                            sh """
                               echo "🔐 Setting up AWS EKS credentials..."
                            aws eks --region ${AWS_REGION} update-kubeconfig --name ${K8S_CLUSTER_NAME}

                            echo "📦 Creating namespace if not exists..."
                            kubectl get namespace ${NAMESPACE} || kubectl create namespace ${NAMESPACE}

                            echo "⚙️ Applying secrets and configmaps..."
                            kubectl apply -n ${NAMESPACE} -f secret.yaml
                            kubectl apply -n ${NAMESPACE} -f configmap.yaml

                            echo "📦 Deploying MySQL..."
                            kubectl apply -n ${NAMESPACE} -f mysql-deployment.yaml
                            kubectl rollout status deployment/mysql -n ${NAMESPACE} --timeout=120s

                            echo "📦 Deploying Application..."
                            export IMAGE=${DOCKER_IMAGE}
                            envsubst < app-deployment.yaml | kubectl apply -n ${NAMESPACE} -f -
                            kubectl rollout status deployment/userportal-app -n ${NAMESPACE} --timeout=120s
                            """
                        }
                    }
                }
            }
        }
        stage('Verify Deployment') {
            steps {
                dir('./k8s/') {
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                    ]) {
                        script {
                            sh """
                                kubectl get pods -n ${NAMESPACE} -o wide
                                kubectl get svc -n ${NAMESPACE}
                            """
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            slackSend(channel: "${SLACK_CHANNEL}", color: 'good', message: "✅ Build #${BUILD_NUMBER} deployed successfully: ${env.IMAGE_TAG ?: 'not-built'}")
        }
        failure {
            slackSend(channel: "${SLACK_CHANNEL}", color: 'danger', message: "❌ Build #${BUILD_NUMBER} failed.")
        }
        always {
            cleanWs()
        }
    }
}