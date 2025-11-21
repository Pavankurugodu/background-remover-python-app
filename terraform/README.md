Terraform AWS Modular Infrastructure

This repository contains a fully modular, production-ready Terraform setup for AWS.

The project uses separate modules for:
VPC
EKS
EC2
Security Groups
S3
IAM
Route53

Environments are managed using Terraform Workspaces (dev, uat) and a reusable module architecture.


terraform/
│
├── backend.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── main.tf
├── terraform.tfvars (optional)
│
├── modules/
│   ├── vpc/
│   ├── eks/
│   ├── ec2/
│   ├── security-groups/
│   ├── s3/
│   ├── iam/
│   └── route53/
│
└── workspaces/
    ├── dev.tfvars
    └── uat.tfvars

How to Initialize and Run Terraform

Initialize Terraform
terraform init

Select Workspace

terraform workspace new dev   # only once
terraform workspace select dev

For UAT:
terraform workspace select uat

Plan
terraform plan -var-file="workspaces/dev.tfvars"

Apply
terraform apply -var-file="workspaces/dev.tfvars"

How Each Module Works & How to Run Them
VPC Module
Purpose

Creates:

VPC

Public subnets

Private subnets

IGW

NAT gateways (optional)

Route tables

How to call the module
module "vpc" {
  source = "./modules/vpc"

  name                 = "bgr"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["ap-south-1a", "ap-south-1b"]
  enable_nat_gateway   = true

  tags = {
    Environment = terraform.workspace
    Project     = "BGR"
  }
}

EKS Module
What This Module Creates

EKS cluster

Node groups

Optional Fargate profiles

Cluster IAM roles

OIDC provider

How to call
module "eks" {
  source = "./modules/eks"

  cluster_name    = "bgr-eks"
  subnet_ids      = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id

  node_groups = {
    default = {
      desired_size = 2
      max_size     = 4
      min_size     = 1
      instance_type = "t3.medium"
    }
  }

  tags = {
    Environment = terraform.workspace
    Project     = "BGR"
  }
}

Production Extensions
Enhancement	Purpose
IRSA (IAM Roles for Service Accounts)	Secure IAM for pods
Node group Launch Templates	Custom AMIs, encryption, bootstrap configs
Multiple node groups	Workload isolation (frontend, backend, GPU, system)
Node taints & tolerations	Control workload placement
Cluster Autoscaler	Auto node scaling
Karpenter	Faster & cost-optimized autoscaling
Calico / Cilium	Network policies
Audit logging	Compliance & security
Encryption at rest (EKS secrets)	Data security


How to Add a New Environment

Create new tfvars:
workspaces/prod.tfvars

Create workspace:
terraform workspace new prod
terraform workspace select prod
terraform apply -var-file="workspaces/prod.tfvars"
