pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
    }

    parameters {
        choice(name: 'ACTION', choices: ['create', 'destroy'], description: 'Choose whether to CREATE or DESTROY the infrastructure')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'infra',
                    credentialsId: 'git-token',
                    url: 'https://github.com/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal.git'
            }
        }

        stage('Terraform Format Check') {
            steps {
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Init & Validate') {
            steps {
                withCredentials([
                    file(credentialsId: 'prod-tfvars', variable: 'TFVARS_FILE'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                ]) {
                    sh '''
                        terraform init
                        terraform validate
                    '''
                }
            }
        }

        stage('Terraform Apply or Destroy') {
            steps {
                withCredentials([
                    file(credentialsId: 'prod-tfvars', variable: 'TFVARS_FILE'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                ]) {
                    script {
                        if (params.ACTION == 'create') {
                            sh '''
                                terraform plan -out=tfplan -var-file=$TFVARS_FILE
                                terraform apply -auto-approve tfplan
                            '''
                        } else if (params.ACTION == 'destroy') {
                            sh '''
                                terraform plan -destroy -out=tfplan -var-file=$TFVARS_FILE
                                terraform destroy -auto-approve -var-file=$TFVARS_FILE
                            '''
                        }
                    }
                }
            }
        }

        stage('Terraform Outputs') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']]) {
                    sh '''
                        echo "==== Terraform Outputs ===="
                        terraform output
                    '''
                }
            }
        }
    }

    post {
        always {
            echo "✅ Cleaning up Jenkins workspace..."
            cleanWs()
        }
        failure {
            echo "❌ Pipeline failed! Check logs for details."
        }
        success {
            echo "🎉 Pipeline succeeded!"
        }
    }
}
