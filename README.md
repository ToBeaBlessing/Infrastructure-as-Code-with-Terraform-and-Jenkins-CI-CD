# Infrastructure as Code with Terraform and Jenkins CI/CD

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Jenkins](https://img.shields.io/badge/jenkins-%232C5263.svg?style=for-the-badge&logo=jenkins&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)
![Flask](https://img.shields.io/badge/flask-%23000.svg?style=for-the-badge&logo=flask&logoColor=white)
![MySQL](https://img.shields.io/badge/mysql-%2300000f.svg?style=for-the-badge&logo=mysql&logoColor=white)

**Enterprise-grade Infrastructure as Code implementation using Terraform modules with Jenkins-orchestrated CI/CD pipeline, featuring remote state management, modular AWS architecture with VPC, EC2, RDS, ALB, and automated Flask REST API deployment with MySQL database backend.**

## 🎯 Project Purpose
<img width="512" height="356" alt="Screenshot 2026-02-09 175243" src="https://github.com/user-attachments/assets/50da878b-7965-4460-9e3c-aeeaf551734f" />

This project demonstrates production-ready Infrastructure as Code practices through:

- **Modular Terraform architecture** with reusable components across networking, compute, database, and load balancing
- **Remote state management** with S3 backend and state locking for team collaboration
- **Jenkins CI/CD pipeline** for automated infrastructure provisioning with parameter-based workflows
- **Multi-tier AWS architecture** with public/private subnets, NAT gateways, and security group best practices
- **End-to-end application deployment** from infrastructure provisioning to Flask REST API with MySQL integration

**Ideal for demonstrating:** Infrastructure Engineer, DevOps Engineer, Cloud Architect, Platform Engineer, or Site Reliability Engineer role competencies.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Infrastructure Setup](#infrastructure-setup)
- [Jenkins Configuration](#jenkins-configuration)
- [Application Deployment](#application-deployment)
- [Testing](#testing)
- [Cleanup](#cleanup)
- [Skills Demonstrated](#skills-demonstrated)
- [Troubleshooting](#troubleshooting)

## 🎯 Overview

This project showcases a complete Infrastructure as Code workflow with two main components:

### Component 1: Jenkins Infrastructure (terraform-jenkins)
- Modular Terraform configuration for Jenkins server
- VPC with public subnets and Internet Gateway
- Application Load Balancer with target groups
- Security groups with least-privilege access
- Remote state management with S3
- Automated Jenkins installation with Terraform provisioner

### Component 2: Multi-Tier Application (devops-project-1)
- Complete VPC architecture (public and private subnets)
- EC2 instances for Flask REST API application
- RDS MySQL database in private subnet
- Application Load Balancer for traffic distribution
- Security group configuration for multi-tier access
- Jenkins pipeline for automated provisioning

### Key Features

| Feature | Technology | Purpose |
|---------|-----------|---------|
| **IaC Tool** | Terraform 1.6.5 | Infrastructure provisioning |
| **CI/CD** | Jenkins | Automated deployment pipeline |
| **State Management** | S3 + DynamoDB | Remote state with locking |
| **Networking** | AWS VPC | Isolated network architecture |
| **Compute** | EC2 | Application hosting |
| **Database** | RDS MySQL | Persistent data storage |
| **Load Balancing** | ALB | Traffic distribution |
| **Application** | Flask (Python) | REST API backend |

## 🏗️ Architecture

### Jenkins Infrastructure Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         AWS Cloud                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │                  VPC (11.0.0.0/16)                    │  │
│  │                                                       │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │         Public Subnet (11.0.1.0/24)         │    │  │
│  │  │                                             │    │  │
│  │  │  ┌──────────────┐         ┌──────────────┐ │    │  │
│  │  │  │   Route 53   │◄────────┤ Application  │ │    │  │
│  │  │  │   (Optional) │         │Load Balancer │ │    │  │
│  │  │  └──────────────┘         └──────┬───────┘ │    │  │
│  │  │                                   │         │    │  │
│  │  │                          ┌────────▼───────┐ │    │  │
│  │  │                          │   Target Group │ │    │  │
│  │  │                          └────────┬───────┘ │    │  │
│  │  │                                   │         │    │  │
│  │  │                          ┌────────▼───────┐ │    │  │
│  │  │                          │  Jenkins EC2   │ │    │  │
│  │  │                          │  - Java 17     │ │    │  │
│  │  │                          │  - Jenkins     │ │    │  │
│  │  │                          │  - Terraform   │ │    │  │
│  │  │                          └────────────────┘ │    │  │
│  │  │                                             │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  │                         │                            │  │
│  │                ┌────────▼────────┐                  │  │
│  │                │ Internet Gateway│                  │  │
│  │                └─────────────────┘                  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

External Storage:
┌─────────────────┐
│   S3 Bucket     │  ← Terraform State Storage
│   (Versioned)   │
└─────────────────┘
```

### Multi-Tier Application Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                          AWS Cloud                                │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │              VPC (eu-central-1) 11.0.0.0/16                │  │
│  │                                                            │  │
│  │  ┌──────────────────────────────────────────────────────┐ │  │
│  │  │         Public Subnet (11.0.1.0/24)                  │ │  │
│  │  │                                                      │ │  │
│  │  │  ┌──────────────┐         ┌──────────────────────┐ │ │  │
│  │  │  │ Application  │◄────────┤  Internet Gateway    │ │ │  │
│  │  │  │Load Balancer │         └──────────────────────┘ │ │  │
│  │  │  └──────┬───────┘                                  │ │  │
│  │  │         │                                          │ │  │
│  │  │  ┌──────▼──────────┐      ┌──────────────────┐   │ │  │
│  │  │  │  Flask REST API │      │   NAT Gateway    │   │ │  │
│  │  │  │  EC2 Instance   │      │  (172.16.0.x)    │   │ │  │
│  │  │  │  - Python/Flask │      └─────────┬────────┘   │ │  │
│  │  │  │  - Port 5000    │                │            │ │  │
│  │  │  └─────────────────┘                │            │ │  │
│  │  │                                     │            │ │  │
│  │  └──────────────────────────────────────┼────────────┘ │  │
│  │                                         │              │  │
│  │  ┌──────────────────────────────────────▼──────────┐  │  │
│  │  │         Private Subnet (11.0.2.0/24)            │  │  │
│  │  │                                                  │  │  │
│  │  │         ┌────────────────────────┐              │  │  │
│  │  │         │   RDS MySQL Database   │              │  │  │
│  │  │         │   - Port 3306          │              │  │  │
│  │  │         │   - Multi-AZ (opt)     │              │  │  │
│  │  │         └────────────────────────┘              │  │  │
│  │  │                                                  │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘

CI/CD Flow:
┌────────────┐     ┌────────────┐     ┌──────────────────┐
│  GitHub    │────►│  Jenkins   │────►│   Terraform      │
│  Repo      │     │  Pipeline  │     │   Plan/Apply     │
└────────────┘     └────────────┘     └──────────────────┘
```

### Jenkins Pipeline Flow

```
Developer Push
      │
      ▼
┌─────────────────────────────────────────────────────┐
│            GitHub Repository                        │
│  - Jenkinsfile                                      │
│  - Terraform modules                                │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│         Jenkins Pipeline Trigger                    │
│  (eu-west-1 Jenkins Server)                        │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│         Build with Parameters                       │
│  • Select: terraform_plan or terraform_apply        │
└─────────────────┬───────────────────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
         ▼                 ▼
┌─────────────────┐  ┌─────────────────┐
│ Terraform Plan  │  │ Terraform Apply │
│ • Init          │  │ • Init          │
│ • Validate      │  │ • Apply         │
│ • Plan          │  │ • Output        │
└─────────────────┘  └─────────────────┘
                           │
                           ▼
         ┌─────────────────────────────────┐
         │  Infrastructure Deployed        │
         │  (eu-central-1 region)          │
         │  • VPC + Subnets                │
         │  • EC2 + Flask API              │
         │  • RDS MySQL                    │
         │  • ALB + Target Groups          │
         └─────────────────────────────────┘
```

## 📁 Project Structure

### Jenkins Infrastructure (terraform-jenkins)

```
terraform-jenkins/
├── modules/
│   ├── certificate-manager/
│   │   └── main.tf                 # ACM certificate (optional)
│   ├── hosted-zone/
│   │   └── main.tf                 # Route53 hosted zone (optional)
│   ├── jenkins/
│   │   ├── main.tf                 # Jenkins EC2 instance
│   │   └── jenkins_installer.sh   # Jenkins setup script
│   ├── jenkins-runner-script/
│   │   └── jenkins.sh              # Jenkins user data script
│   ├── load-balancer/
│   │   └── main.tf                 # Application Load Balancer
│   ├── load-balancer-target-group/
│   │   └── main.tf                 # ALB target group
│   ├── networking/
│   │   └── main.tf                 # VPC, subnets, route tables
│   ├── providers/
│   │   └── main.tf                 # Terraform providers config
│   └── security-groups/
│       ├── main.tf                 # Security group definitions
│       └── terraform.lock.hcl
├── s3-state-bucket.tf              # S3 bucket for state storage
├── remote_backend_s3.tf            # S3 backend configuration
├── main.tf                         # Root module configuration
├── outputs.tf                      # Output definitions
├── provider.tf                     # AWS provider settings
├── terraform.tfvars                # Variable values
├── variables.tf                    # Variable declarations
└── README.md
```

### Multi-Tier Application (devops-project-1)

```
devops-project-1/
├── infra/
│   ├── .terraform/                 # Terraform plugins
│   ├── certificate-manager/
│   │   └── main.tf
│   ├── ec2/
│   │   └── main.tf                 # Application EC2 instances
│   ├── hosted-zone/
│   │   └── main.tf
│   ├── load-balancer/
│   │   └── main.tf
│   ├── load-balancer-target-group/
│   │   └── main.tf
│   ├── networking/
│   │   └── main.tf                 # VPC with private subnets
│   ├── rds/
│   │   └── main.tf                 # RDS MySQL database
│   ├── s3/
│   │   └── main.tf                 # S3 buckets
│   ├── security-groups/
│   │   └── main.tf
│   ├── template/
│   │   ├── terraform.lock.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── remote_backend_s3.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── app.py                      # Flask REST API application
├── Jenkinsfile                     # Pipeline definition
└── README.md
```

## ✅ Prerequisites

### Required Tools

- [Terraform](https://www.terraform.io/downloads) (v1.6.5+)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- [Git](https://git-scm.com/)
- SSH client (Git Bash for Windows, native terminal for macOS/Linux)
- Text editor (VS Code recommended)

### Required Accounts

- AWS account with administrative permissions
- GitHub account

### AWS Permissions Required

- EC2 full access
- VPC full access
- S3 full access
- RDS full access
- ELB full access
- IAM permissions for creating roles

## 🚀 Infrastructure Setup

### Phase 1: Jenkins Infrastructure Provisioning

#### Step 1: Configure AWS Credentials

```bash
# Configure AWS CLI
aws configure

# You'll be prompted for:
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]
# Default region: eu-west-1
# Default output format: json
```

#### Step 2: Prepare Terraform Configuration

Clone the repository and navigate to the project:

```bash
git clone <your-terraform-jenkins-repo>
cd terraform-jenkins
```

**Clean the `provider.tf`:**

```bash
# Remove any hardcoded credentials from provider.tf
# The file should look like:
```

```hcl
# provider.tf
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  # Credentials come from AWS CLI or environment variables
}
```

**Comment out remote backend initially:**

```hcl
# remote_backend_s3.tf
# Comment this entire file for now
# terraform {
#   backend "s3" {
#     bucket = "dev-proj-1-jenkins-remote-state-bucket-123456"
#     key    = "jenkins/terraform.tfstate"
#     region = "eu-west-1"
#   }
# }
```

**Comment out most of `main.tf`:**

```hcl
# main.tf
# Keep only the networking module initially
module "networking" {
  source = "./modules/networking"
  # ... networking configuration
}

# Comment out everything else for now:
# module "security_group" { ... }
# module "jenkins" { ... }
# module "lb_target_group" { ... }
# module "alb" { ... }
```

**Comment out sections in `networking/main.tf`:**

```hcl
# networking/main.tf
# Keep VPC and public subnet
# Comment out from Internet Gateway down:
# resource "aws_internet_gateway" "igw" { ... }
# resource "aws_route_table" "public" { ... }
# resource "aws_route_table_association" "public" { ... }
```

#### Step 3: Create S3 State Bucket

Create `s3-state-bucket.tf`:

```hcl
# s3-state-bucket.tf
resource "aws_s3_bucket" "terraform_state" {
  bucket = "dev-proj-1-jenkins-remote-state-bucket-123456"  # Must be globally unique

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "dev"
    Project     = "Jenkins"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

**Initialize and create the bucket:**

```bash
terraform init
terraform plan
terraform apply -auto-approve
```

**Verify in AWS Console:**
- Go to S3 → Buckets
- Confirm bucket exists with versioning enabled

#### Step 4: Incremental Infrastructure Build

**Uncomment Internet Gateway in `networking/main.tf`:**

```bash
# Edit networking/main.tf and uncomment Internet Gateway resource
```

**Enable remote backend:**

```bash
# Uncomment remote_backend_s3.tf

terraform init -migrate-state
# Type 'yes' when prompted to migrate state

terraform plan
terraform apply -auto-approve
```

**Uncomment public route table (but not associations):**

```bash
terraform plan
terraform apply -auto-approve
```

**Uncomment route table associations:**

```bash
terraform plan
terraform apply -auto-approve
```

**Uncomment security group in `main.tf`:**

```bash
# Review security group configuration in ./modules/security-groups/
terraform plan
terraform apply -auto-approve
```

**Uncomment Jenkins module:**

```bash
# Review Jenkins configuration in ./modules/jenkins/
terraform plan
terraform apply -auto-approve
```

#### Step 5: Generate SSH Key

**On Windows (PowerShell or Command Prompt):**

```powershell
# Generate SSH key pair
ssh-keygen -t ed25519 -C "jenkins-demo"

# When prompted:
# Enter file in which to save the key: C:\Users\<YOUR_USERNAME>\.ssh\jenkins_demo
# Enter passphrase (optional): [press Enter for no passphrase]
```

**On macOS/Linux or Git Bash:**

```bash
ssh-keygen -t ed25519 -C "jenkins-demo"

# Save to: ~/.ssh/jenkins_demo
```

**View your SSH keys:**

```powershell
# Windows PowerShell
dir C:\Users\<YOUR_USERNAME>\.ssh

# Git Bash or macOS/Linux
ls -la ~/.ssh
```

**Copy public key:**

```bash
# Windows Git Bash
cat C:/Users/<YOUR_USERNAME>/.ssh/jenkins_demo.pub

# macOS/Linux
cat ~/.ssh/jenkins_demo.pub
```

Copy the entire output (starts with `ssh-ed25519`).

**Add public key to `terraform.tfvars`:**

```hcl
# terraform.tfvars
public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG... jenkins-demo"
```

**Apply configuration:**

```bash
terraform plan
terraform apply -auto-approve
```

#### Step 6: Access Jenkins

**Get Jenkins public IP:**

```bash
# From Terraform output
terraform output jenkins_public_ip

# Or check AWS Console → EC2 → Instances
```

**Retrieve Jenkins initial password:**

```bash
# SSH into Jenkins instance
ssh -i "C:/Users/<YOUR_USERNAME>/.ssh/jenkins_demo" ubuntu@<JENKINS_PUBLIC_IP>

# Get initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**Alternative - Remote command:**

```bash
ssh -i "C:/Users/<YOUR_USERNAME>/.ssh/jenkins_demo" ubuntu@<JENKINS_PUBLIC_IP> "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

**Check installation logs if needed:**

```bash
ssh -i "C:/Users/<YOUR_USERNAME>/.ssh/jenkins_demo" ubuntu@<JENKINS_PUBLIC_IP> "sudo cat /var/log/cloud-init-output.log | grep -A 5 -B 5 jenkins"
```

**Access Jenkins UI:**

1. Open browser: `http://<JENKINS_PUBLIC_IP>:8080`
2. Paste the initial admin password
3. Click "Install suggested plugins"
4. Create admin user
5. Save and finish

#### Step 7: Configure Load Balancer (Optional)

If you want to use ALB instead of direct IP access:

**Uncomment load balancer target group:**

```bash
terraform plan
terraform apply -auto-approve
```

**For setups without a domain:**

Comment out Route53 and Certificate Manager in `main.tf`:

```hcl
# Comment out:
# module "hosted_zone" { ... }
# module "certificate_manager" { ... }
```

**Update ALB configuration:**

In `modules/load-balancer/main.tf`, modify:

```hcl
# Change is_external to true
is_external = true

# Use dummy certificate ARN
acm_certificate_arn = "arn:aws:acm:eu-west-1:123456789012:certificate/dummy"
```

**Add ALB DNS output:**

```hcl
# outputs.tf
output "jenkins_url" {
  description = "The DNS name of the load balancer to access Jenkins"
  value       = "http://${module.alb.aws_lb_dns_name}"
}
```

**Apply changes:**

```bash
terraform plan
terraform apply -auto-approve
```

**Access via ALB:**

```bash
# Get ALB DNS name
terraform output jenkins_url

# Open in browser
```

### Phase 2: Multi-Tier Application Deployment

#### Step 1: Clone Application Repository

```bash
git clone <devops-project-1-repo>
cd devops-project-1/infra
```

#### Step 2: Update SSH Public Key

Edit `terraform.tfvars`:

```hcl
# terraform.tfvars
public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG... jenkins-demo"
# Use the same key you generated earlier
```

#### Step 3: Create S3 State Bucket

**In AWS Console:**
1. Go to S3 → Create bucket
2. Bucket name: `dev-proj-1-remote-state-bucketu` (must be globally unique)
3. Region: `eu-central-1`
4. Enable versioning
5. Create bucket

## 🔧 Jenkins Configuration

### Step 1: Install AWS Steps Plugin

1. Go to Jenkins → Manage Jenkins → Plugins
2. Click "Available plugins"
3. Search for "Pipeline: AWS Steps"
4. Select and install
5. Restart Jenkins if needed

### Step 2: Add AWS Credentials

1. Go to Manage Jenkins → Credentials
2. Click "(global)" under Domains
3. Click "Add Credentials"
4. **Kind:** AWS Credentials
5. **ID:** `aws-credentials` (match the ID in your Jenkinsfile)
6. **Access Key ID:** Your AWS access key
7. **Secret Access Key:** Your AWS secret key
8. **Description:** AWS Credentials for Terraform
9. Click "Create"

### Step 3: Create Jenkins Pipeline

1. Click "New Item"
2. **Item name:** `dev-project-1-eu-central-1-pipeline`
3. Select "Pipeline"
4. Click "OK"

**Pipeline Configuration:**

1. Scroll to "Pipeline" section
2. **Definition:** Pipeline script from SCM
3. **SCM:** Git
4. **Repository URL:** `https://github.com/<YOUR_USERNAME>/devops-project-1.git`
5. **Credentials:** None (for public repo)
6. **Branch Specifier:** `*/main` (or your branch name)
7. **Script Path:** `Jenkinsfile`
8. Click "Save"

### Step 4: Run Pipeline

**First Run - Plan:**

1. Click "Build with Parameters"
2. Select **Action:** `terraform_plan`
3. Click "Build"
4. Monitor console output
5. Review planned changes

**Second Run - Apply:**

1. Click "Build with Parameters"
2. Select **Action:** `terraform_apply`
3. Click "Build"
4. Wait for infrastructure provisioning (5-10 minutes)

### Step 5: Verify Infrastructure

```bash
# Check EC2 instances
aws ec2 describe-instances --region eu-central-1 --filters "Name=tag:Project,Values=DevOps"

# Check RDS instance
aws rds describe-db-instances --region eu-central-1
```

## 🚀 Application Deployment

### Step 1: Get Application EC2 Public IP

From Jenkins pipeline output or AWS Console:

```bash
# Note the Flask API EC2 public IP
```

### Step 2: Configure Database Connection

**SSH into Flask API instance:**

```bash
ssh -i "C:/Users/<YOUR_USERNAME>/.ssh/jenkins_demo" ec2-user@<FLASK_API_PUBLIC_IP>
```

**Update `app.py` with RDS endpoint:**

Get RDS endpoint from AWS Console or Terraform output, then:

```python
# app.py
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://admin:password@<RDS_ENDPOINT>:3306/flask_db'
```

### Step 3: Update RDS Security Group

**Allow EC2 to access RDS:**

1. Go to AWS Console → RDS → Databases → Your DB
2. Click on VPC security group
3. Edit inbound rules
4. Add rule:
   - **Type:** MYSQL/Aurora
   - **Port:** 3306
   - **Source:** Security group of EC2 instance (sg-xxxxxxxx)
5. Save rules

### Step 4: Initialize Database

**Create database table:**

```bash
# In browser, access:
http://<FLASK_API_PUBLIC_IP>:5000/create_table
```

You should see: "Table created successfully!"

### Step 5: Test REST API

**Insert a record:**

```bash
# Via browser UI
http://<FLASK_API_PUBLIC_IP>:5000

# Enter a name and click "Insert Record"
```

**Or via curl:**

```bash
curl -X POST http://<FLASK_API_PUBLIC_IP>:5000/insert \
  -H "Content-Type: application/json" \
  -d '{"name": "test-record-1"}'
```

**View data:**

```bash
# In browser
http://<FLASK_API_PUBLIC_IP>:5000

# Or via curl
curl http://<FLASK_API_PUBLIC_IP>:5000/data
```

## 🧪 Testing

### Infrastructure Testing

```bash
# Test Jenkins access
curl -I http://<JENKINS_IP>:8080

# Test Flask API health
curl http://<FLASK_IP>:5000/health

# Test database connectivity
ssh -i ~/.ssh/jenkins_demo ec2-user@<FLASK_IP>
mysql -h <RDS_ENDPOINT> -u admin -p
```

### Application Testing

```bash
# Insert test record
curl -X POST http://<FLASK_IP>:5000/insert \
  -H "Content-Type: application/json" \
  -d '{"name": "test-record-2"}'

# Retrieve all records
curl http://<FLASK_IP>:5000/data

# Expected output:
# [
#   {"id": 1, "name": "test-record-1"},
#   {"id": 2, "name": "test-record-2"}
# ]
```

### Validation Checklist

- [ ] Jenkins UI accessible
- [ ] Jenkins pipeline runs successfully
- [ ] VPC and subnets created
- [ ] EC2 instances running
- [ ] RDS database accessible from EC2
- [ ] Security groups properly configured
- [ ] Flask API responding on port 5000
- [ ] Database CRUD operations working
- [ ] Terraform state stored in S3

## 🧹 Cleanup

### Destroy Application Infrastructure

**Via Jenkins:**

1. Modify Jenkinsfile to add `terraform destroy`
2. Or run manually from Jenkins server

**Via Command Line:**

```bash
cd devops-project-1/infra

# Initialize Terraform
terraform init

# Destroy infrastructure
terraform destroy -auto-approve
```

### Destroy Jenkins Infrastructure

```bash
cd terraform-jenkins

# Destroy all resources
terraform destroy -auto-approve
```

### Delete S3 State Buckets

```bash
# Delete state files first
aws s3 rm s3://dev-proj-1-jenkins-remote-state-bucket-123456 --recursive
aws s3 rm s3://dev-proj-1-remote-state-bucketu --recursive

# Delete buckets
aws s3 rb s3://dev-proj-1-jenkins-remote-state-bucket-123456
aws s3 rb s3://dev-proj-1-remote-state-bucketu
```

### Remove Local Terraform Files

```bash
# Remove state files
rm -rf .terraform
rm -f .terraform.lock.hcl
rm -f terraform.tfstate*
```

## 💼 Skills Demonstrated

This project showcases expertise in:

### Infrastructure as Code
- ✅ **Terraform Mastery:** Modular architecture with reusable components
- ✅ **State Management:** Remote state with S3, versioning, and locking
- ✅ **Incremental Deployment:** Phased infrastructure provisioning
- ✅ **Best Practices:** Variables, outputs, and proper module structure

### CI/CD & Automation
- 🔄 **Jenkins Pipelines:** Parameterized builds with plan/apply workflow
- 📦 **Automated Provisioning:** Infrastructure deployment via Jenkins
- 🔐 **Secrets Management:** AWS credentials integration in Jenkins
- 📊 **Pipeline as Code:** Jenkinsfile-based pipeline definitions

### AWS Architecture
- ☁️ **Multi-Tier Design:** Public/private subnet architecture
- 🌐 **Networking:** VPC, subnets, Internet Gateway, NAT Gateway, route tables
- 🖥️ **Compute:** EC2 instance configuration and management
- 💾 **Database:** RDS MySQL with proper security group isolation
- ⚖️ **Load Balancing:** Application Load Balancer with target groups
- 🔒 **Security:** Security group best practices with least-privilege access

### Application Development
- 🐍 **Backend Development:** Flask REST API with Python
- 🗄️ **Database Integration:** SQLAlchemy ORM with MySQL
- 🔌 **API Design:** RESTful endpoints for CRUD operations
- 🛠️ **Configuration Management:** Environment-based database connections

### DevOps Practices
- 📝 **Documentation:** Comprehensive infrastructure documentation
- 🔧 **Troubleshooting:** Log analysis and debugging capabilities
- 🧪 **Testing:** Infrastructure validation and application testing
- 🔄 **Incremental Deployment:** Staged infrastructure rollout

## 🔧 Troubleshooting

### Terraform Issues

**Issue:** State lock error

**Solution:**
```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>

# Or delete lock from DynamoDB if using state locking
```

**Issue:** Provider authentication errors

**Solution:**
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Reconfigure if needed
aws configure

# Check credentials file
cat ~/.aws/credentials
```

**Issue:** Resource already exists

**Solution:**
```bash
# Import existing resource
terraform import aws_s3_bucket.terraform_state <BUCKET_NAME>

# Or destroy and recreate
terraform destroy -target=aws_s3_bucket.terraform_state
terraform apply
```

### Jenkins Issues

**Issue:** Jenkins not accessible after installation

**Solution:**
```bash
# Check Jenkins status
ssh -i ~/.ssh/jenkins_demo ubuntu@<JENKINS_IP> "sudo systemctl status jenkins"

# View logs
ssh -i ~/.ssh/jenkins_demo ubuntu@<JENKINS_IP> "sudo journalctl -u jenkins -n 50"

# Restart Jenkins
ssh -i ~/.ssh/jenkins_demo ubuntu@<JENKINS_IP> "sudo systemctl restart jenkins"
```

**Issue:** Initial admin password not found

**Solution:**
```bash
# Wait for Jenkins to fully initialize (may take 2-3 minutes)
sleep 120

# Then retrieve password
ssh -i ~/.ssh/jenkins_demo ubuntu@<JENKINS_IP> "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
```

**Issue:** Pipeline fails with AWS credentials error

**Solution:**
1. Verify credentials ID in Jenkinsfile matches Jenkins credentials
2. Test AWS access from Jenkins:
```groovy
// In Jenkins script console
withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
    sh 'aws sts get-caller-identity'
}
```

### RDS Connectivity Issues

**Issue:** EC2 cannot connect to RDS

**Solution:**
```bash
# 1. Verify security group rules
aws ec2 describe-security-groups --group-ids <RDS_SG_ID>

# 2. Check if rule allows EC2 SG
# Should see: Source: sg-xxxxxxxx (EC2 security group)

# 3. Test connectivity from EC2
ssh -i ~/.ssh/jenkins_demo ec2-user@<EC2_IP>
telnet <RDS_ENDPOINT> 3306

# 4. If telnet fails, update security group:
# AWS Console → RDS → Security Groups → Inbound Rules → Add Rule
# Type: MYSQL/Aurora, Port: 3306, Source: <EC2_SG_ID>
```

**Issue:** RDS endpoint not resolving

**Solution:**
```bash
# Get RDS endpoint from AWS
aws rds describe-db-instances --region eu-central-1 \
  --query 'DBInstances[0].Endpoint.Address' --output text

# Update app.py with correct endpoint
```

### Flask Application Issues

**Issue:** Application not responding on port 5000

**Solution:**
```bash
# SSH into EC2
ssh -i ~/.ssh/jenkins_demo ec2-user@<EC2_IP>

# Check if Flask is running
ps aux | grep python

# Check security group allows port 5000
# AWS Console → EC2 → Security Groups
# Inbound: Type: Custom TCP, Port: 5000, Source: 0.0.0.0/0

# Manually start Flask if needed
cd /path/to/app
python3 app.py
```

**Issue:** Database table creation fails

**Solution:**
```bash
# SSH into EC2 and check database connection
python3
>>> from app import app, db
>>> with app.app_context():
>>>     db.create_all()

# Or manually create table in MySQL
mysql -h <RDS_ENDPOINT> -u admin -p
CREATE DATABASE IF NOT EXISTS flask_db;
USE flask_db;
CREATE TABLE IF NOT EXISTS records (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255));
```

### SSH Connection Issues

**Issue:** Permission denied (publickey)

**Solution:**
```bash
# Verify key permissions (must be 600)
chmod 600 ~/.ssh/jenkins_demo

# Use correct username:
# - Ubuntu AMI: ubuntu
# - Amazon Linux: ec2-user
# - RHEL: ec2-user or root

# Verify key in use
ssh -i ~/.ssh/jenkins_demo -v ubuntu@<IP>
```

**Issue:** SSH key not found

**Solution:**
```bash
# Windows (Git Bash)
ls -la /c/Users/<USERNAME>/.ssh/

# macOS/Linux
ls -la ~/.ssh/

# If missing, regenerate
ssh-keygen -t ed25519 -C "jenkins-demo"
```

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-best-practices.html)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [SQLAlchemy ORM](https://docs.sqlalchemy.org/)
- [Terraform Module Registry](https://registry.terraform.io/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## 🚀 Future Enhancements

- [ ] Implement Terraform state locking with DynamoDB
- [ ] Add auto-scaling groups for EC2 instances
- [ ] Configure RDS Multi-AZ for high availability
- [ ] Implement CloudWatch monitoring and alarms
- [ ] Add SSL/TLS certificates with ACM
- [ ] Configure Route53 for custom domain
- [ ] Implement blue-green deployment strategy
- [ ] Add WAF rules for additional security
- [ ] Configure CloudFront for content delivery
- [ ] Implement backup and disaster recovery
- [ ] Add cost optimization with reserved instances
- [ ] Implement infrastructure testing with Terratest
- [ ] Add Prometheus and Grafana monitoring
- [ ] Configure ECS/EKS for container orchestration
- [ ] Implement secrets management with AWS Secrets Manager

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Author:** Blessing Omomola  
**Institution:** Morgan State University - Industrial Engineering (MS)  
**Certifications:** AWS Solutions Architect Associate, AWS Cloud Practitioner  
**GitHub:** [@ToBeaBlessing](https://github.com/ToBeaBlessing)  
**LinkedIn:** [Connect with me](https://linkedin.com/in/yourprofile)

⭐ If this project demonstrates valuable Infrastructure as Code and CI/CD skills, please star it!
