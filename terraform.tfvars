# General
region      = "ap-south-1"
environment = "dev"
Name        = "SpringBoot-Fullstack-UserPortal"

tags = {
  Project     = "SpringBoot-Fullstack-UserPortal"
  Name        = "SpringBoot-Fullstack-UserPortal"
  Environment = "Dev"
  Owner       = "Rahul"
}

# VPC
vpc_cidr                          = "10.0.0.0/16"
public_subnet_cidrs               = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs              = ["10.0.101.0/24", "10.0.102.0/24"]
public_subnet_availability_zones  = ["ap-south-1a", "ap-south-1b"]
private_subnet_availability_zones = ["ap-south-1a", "ap-south-1b"]

# EC2
key_name      = "AWS_Key_Pair"
instance_type = "c7i-flex.large"
volume_size   = 25
volume_type   = "gp3"


# EKS
eks_cluster_name     = "SpringBoot-eks-cluster"
eks_version          = "1.33"
desired_worker_count = 2
min_worker_count     = 1
max_worker_count     = 3
node_instance_type   = "t3.small"

