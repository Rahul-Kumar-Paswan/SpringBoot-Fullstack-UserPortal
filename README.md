# 🚀 SpringBoot-Fullstack-UserPortal — Terraform | Jenkins | EKS | IRSA

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repo-181717?logo=github)](https://github.com/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal)
[![Contributors](https://img.shields.io/github/contributors/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal?color=blue)](https://github.com/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal/graphs/contributors)
[![Contributors](https://img.shields.io/github/contributors/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal?color=blue)](https://github.com/Rahul-Kumar-Paswan/SpringBoot-Fullstack-UserPortal/graphs/contributors)
[![AWS](https://img.shields.io/badge/AWS-EKS|EC2|IRSA-orange?logo=amazon-aws&logoColor=white)]
![Docker](https://img.shields.io/badge/Docker-Ready-blue?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS-brightgreen?logo=kubernetes&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![CI/CD](https://img.shields.io/badge/Jenkins-CI%2FCD-orange?logo=jenkins)
![License](https://img.shields.io/badge/License-MIT-yellow)

---
A production-grade **DevOps** project that automates the provisioning of a complete **3-tier AWS infrastructure** for a **SpringBoot Fullstack User Portal** using **Terraform**, orchestrated with a **Jenkins CI/CD pipeline** to create or destroy environments on demand.

 - Architecture Includes:

- **Custom VPC** for network isolation and security.
- **EKS Cluster** with **IRSA** (IAM Roles for Service Accounts) for secure AWS API access from Kubernetes pods.
- **EC2 instances** prepared for DevOps tools: Jenkins, SonarQube, Nexus

---

## 🧭 Table of Contents

- [🖥️ Project Overview](#project-overview)
- [🌐 Application Overview](#application-overview)
- [🌟 Key Features](#key-features)
- [🧰 Tech Stack](#tech-stack)
- [📂 Project Structure](#project-structure)
- [⚙️ Infrastructure Overview](#infrastructure-overview)
- [🔐 IAM and Security](#iam-and-security)
- [📦 Jenkins Pipeline (CI/CD)](#jenkins-pipeline-cicd)
- [🌍 Requirements & Deployment](#requirements--deployment)
- [📊 Terraform Outputs](#terraform-outputs)
- [🧼 Cost Optimization](#cost-optimization)
- [🧑‍💻 Author](#author)
- [📝 License](#license)

---
## 🖥️ Project Overview

This project demonstrates:

- **Automated AWS infrastructure provisioning** with **Terraform**
- **Secure and automated CI/CD workflows** using **Jenkins**
- **Managed Kubernetes workloads** on **EKS** with **IRSA for add-ons** (EBS CSI driver)
- **Infrastructure as Code (IaC)** approach with modular and scalable design
- **Deployment automation** and environment lifecycle management (**create/destroy**)

---
## 🌐 Application Overview

This project deploys a **Spring Boot backend** with a **React frontend** (User Portal).  
The backend connects to a **MySQL database** deployed as a Kubernetes StatefulSet.  
All services are containerized and orchestrated within EKS for scalability.

---
## 🧩 Key Features

| Category                  | Features                                                                       |
| ------------------------- | ------------------------------------------------------------------------------ |
| ☁️ **AWS Infrastructure** | VPC, EKS Cluster, Managed Node Groups, EC2 for Jenkins, SonarQube & Nexus      |
| ⚙️ **Automation**         | Jenkins Pipeline to create/destroy Terraform-managed infrastructure            |
| 🔐 **Security**           | IRSA (IAM Roles for Service Accounts), least-privilege IAM Policies            |
| 📦 **Add-ons**            | EBS CSI Driver, OIDC Provider Integration                                      |
| 🧠 **Best Practices**     | Remote State Backend (S3 + DynamoDB), Modular Terraform Code |

---
## 🧰 Tech Stack
| **Category**                  | **Tool/Technology**         | **Description**                                                         |
| ----------------------------- | --------------------------- | ----------------------------------------------------------------------- |
| **Infrastructure as Code**    | Terraform                   | Provision and manage AWS infrastructure declaratively.                  |
| **Cloud Provider**            | AWS                         | Core cloud platform (VPC, EC2, EKS, IAM).                               |
| **Container Orchestration**   | Kubernetes (EKS)            | Managed cluster for running containerized apps.                         |
| **CI/CD Automation**          | Jenkins                     | Automates infrastructure provisioning and app deployments.              |
| **Configuration Management**  | Kubernetes manifests (YAML) | Deploy/manage application resources (Deployments, ConfigMaps, Secrets). |
| **Security & Access Control** | IAM / RBAC                  | Manage permissions for AWS and Kubernetes.                              |
| **Scripting**                 | Bash/Shell                  | Automation scripts for EC2 and other services.                          |
| **Version Control**           | Git / GitHub                | Repository and collaboration management.                                |

---
## 📂 Project Structure

```bash
.
├── Jenkinsfile                  # Jenkins CI/CD pipeline
├── README.md                    # Project documentation
├── main.tf                      # Root Terraform configuration
├── modules/                     # Terraform modules
│   ├── ec2/                     # EC2 instance provisioning
│   ├── eks/                     # EKS cluster provisioning
│   └── vpcs/                    # VPC resources
├── output.tf                    # Terraform outputs
├── scripts/                     # Utility scripts
│   ├── jenkins-setup.sh
│   ├── nexus-setup.sh
│   └── sonarqube-setup.sh
├── server-setup.sh              # EC2 server setup script
├── terraform.tfvars             # Default Terraform variables
└── variables.tf                 # Global Terraform variable definitions
```
---
## ⚙️ Infrastructure Overview

### 🏗️ VPC Module

- Creates a custom **VPC** with public/private subnets across **Availability Zones (AZs)**.
- Configures **Internet Gateway**, **NAT Gateway**, and **route tables**.
- Tags subnets for **EKS** integration.

---
### ☸️ EKS Module

- Provisions an **EKS cluster** with **managed node groups**.
- Sets up **OIDC provider** for **IRSA** integration.
- Installs **EBS CSI driver** for persistent storage in Kubernetes.
- Configures **Kubernetes provider** for Terraform via **AWS authentication**.

---
### 💻 EC2 Module

- Provisions **EC2 instances** for **Jenkins**, **SonarQube**, **Nexus**
- Bootstraps EC2 with **Docker installation scripts** to automate setup.

---
## 🔐 IAM and Security
### 🔒 IRSA Roles Created:
| Service | IAM Role            | Purpose                                                      |
| ------- | ------------------- | ------------------------------------------------------------ |
| EBS CSI | `ebs-csi-irsa-role` | Allows EBS volume provisioning within EKS                    |

---
## 📦 Jenkins Pipeline (CI/CD)
### 🧠 Parameters
```groovy
parameters {
    choice(name: 'ACTION', choices: ['create', 'destroy'])
}
```
### 🪜 Stages
| Stage                | Description                                 |
| -------------------- | ------------------------------------------- |
| **Checkout Code**    | Clones Terraform repo via GitHub token      |
| **Init & Validate**  | Initializes backend and validates syntax    |
| **Terraform Plan**   | Dry-run to show changes before apply        |
| **Apply or Destroy** | Executes based on parameter                 |
| **Output Summary**   | Displays infrastructure outputs post-deploy |

### 🔐 Jenkins Credentials
| ID            | Description                          |
| ------------- | ------------------------------------ |
| `aws-cred`    | AWS IAM Access for Terraform backend |
| `git-token`   | GitHub access token for repo         |
| `prod-tfvars` | Encrypted tfvars for production      |

### 🔄 CI/CD Workflow

1. **Code Push** → triggers Jenkins webhook  
2. Jenkins executes **Terraform pipeline** (create/destroy infra)  
3. **EKS cluster** ready → Jenkins deploys K8s manifests (`k8s/` folder)  
4. **IRSA role** allows the EBS CSI Driver to provision EBS volumes securely 
5. CI/CD completes → App accessible via **LoadBalancer or Ingress**

---
## 🌍 Requirements & Deployment
### 🔧 Prerequisites
| Tool      | Version | Purpose                 |
| --------- | ------- | ----------------------- |
| Terraform | ≥ 1.3   | IaC engine              |
| AWS CLI   | ≥ 2.0   | AWS operations          |
| kubectl   | latest  | K8s resource management |
| Jenkins   | latest  | Pipeline execution      |

### 🚀 Deployment Steps

1. **Clone repo locally** or on the build server.
2. **Trigger Jenkins pipeline**, select **create** or **destroy**.
3. Jenkins handles **Terraform provisioning** accordingly.
4. Optionally, **deploy via CLI**.
5. **Access Terraform outputs** for resource details.

---
## 📊 Terraform Outputs
| Output                    | Description                |
| ------------------------- | -------------------------- |
| `vpc_id`                  | Custom VPC ID              |
| `public_subnet_ids`       | IDs of public subnets      |
| `private_subnet_ids`      | IDs of private subnets     |
| `eks_cluster_name`        | EKS Cluster Name           |
| `eks_cluster_endpoint`    | EKS API endpoint           |
| `jenkins_ec2_public_ip`   | Jenkins EC2 public IP      |
| `nexus_ec2_public_ip`     | Nexus EC2 public IP        |
| `sonarqube_ec2_public_ip` | SonarQube EC2 public IP    |
| `eks_oidc_provider_arn`   | OIDC provider ARN for IRSA |

---
## 🧼 Cost Optimization

- **Destroy unused infrastructure regularly** to minimize ongoing costs.
  ```bash
      terraform destroy -auto-approve -var-file=envs/prod.tfvars
  ```
- **Clean up residual AWS resources** to avoid unnecessary charges, including:
  - **Load Balancers**
  - **EBS Volumes**

---

## 🧑‍💻 Author

**Rahul Kumar Paswan**  
GitHub: [@Rahul-Kumar-Paswan](https://github.com/Rahul-Kumar-Paswan)

---
## 📝 License

MIT License © 2025 Rahul Paswan
This project is licensed under the [MIT License](./LICENSE).