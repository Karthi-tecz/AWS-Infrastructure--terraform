# Production-Ready 3-Tier AWS Architecture using Terraform

## Project Overview

This project implements a **highly available, scalable, and secure cloud infrastructure on AWS** using **Terraform (Infrastructure as Code)**. The architecture supports a modern web application with a **static frontend, scalable backend, secure database layer, and event-driven automation**.

The infrastructure is designed following **AWS best practices**, including **Multi-AZ deployment, load balancing, auto scaling, CDN acceleration, and serverless monitoring**.

The application domain is **techhodude.co.in**, which is managed using **Route53 DNS**.

---

## Architecture Overview

The system follows a **3-tier architecture** deployed within an AWS region.

### 1. Networking Layer

A custom **Virtual Private Cloud (VPC)** is created to isolate and secure the infrastructure.

Components:

* VPC with CIDR block `10.0.0.0/16`
* 2 Public Subnets (for Load Balancer and EC2)
* 2 Private Subnets (for Database)
* Internet Gateway
* NAT Gateway
* Public and Private Route Tables

This ensures **secure communication and controlled internet access**.

---

### 2. Application Layer (Backend)

The backend application is deployed on **EC2 instances** that automatically scale based on demand.

Components:

* Application Load Balancer (ALB)
* Launch Template
* Auto Scaling Group (minimum 2 instances)
* EC2 instances across multiple Availability Zones

Traffic Flow:

User → Route53 → ALB → EC2 → RDS

Benefits:

* High availability
* Automatic scaling
* Fault tolerance

---

### 3. Database Layer

The database is hosted using **Amazon RDS (MySQL)**.

Features:

* Deployed in **private subnets**
* Not publicly accessible
* Secured using **security groups**
* Accessible only from EC2 instances

This ensures **secure and reliable data storage**.

---

### 4. Static Frontend Hosting

The frontend application is hosted using **Amazon S3** and delivered globally using **CloudFront CDN**.

Components:

* S3 Bucket (Static Website Hosting)
* CloudFront Distribution
* ACM SSL Certificate
* Route53 DNS integration

Traffic Flow:

User → Route53 → CloudFront → S3

Benefits:

* Global low latency
* HTTPS support
* Improved performance
* Built-in DDoS protection

---

### 5. Domain and DNS Management

The domain **techhodude.co.in** is managed using **Amazon Route53**.

DNS records include:

* A record pointing to **Application Load Balancer**
* A record pointing to **CloudFront distribution**

This allows users to securely access the application using:

* https://techhodude.co.in
* https://www.techhodude.co.in

---

### 6. Event-Driven Monitoring System

The architecture includes a **serverless monitoring and automation pipeline**.

Components:

* CloudWatch Events
* AWS Lambda
* SNS (Simple Notification Service)
* SQS (Simple Queue Service)

Event Flow:

CloudWatch → Lambda → SNS → SQS

Purpose:

* Automated monitoring
* Alert notifications
* Decoupled service communication
* Reliable message processing

---

## Security Features

* Private database layer
* NAT Gateway for private subnet internet access
* IAM roles with least privilege access
* HTTPS enabled using ACM certificates
* Security groups for controlled network access
* Multi-AZ deployment for fault tolerance

---


## Infrastructure as Code

All resources are provisioned using **Terraform**, enabling:

* Version-controlled infrastructure
* Repeatable deployments
* Automated provisioning
* Consistent environments

---

## Project Structure

```
terraform-aws-infrastructure/
│
├── provider.tf
├── variables.tf
├── networking.tf
├── compute.tf
├── database.tf
├── s3_cloudfront.tf
├── lambda_sns_sqs.tf
├── route53.tf
├── iam.tf
└── outputs.tf
```

---

## Deployment Steps

Initialize Terraform:

```
terraform init
```

Validate configuration:

```
terraform validate
```

Preview infrastructure changes:

```
terraform plan
```

Deploy infrastructure:

```
terraform apply
```

---

## Technologies Used

* AWS
* Terraform
* Amazon EC2
* Application Load Balancer
* Amazon RDS
* Amazon S3
* Amazon CloudFront
* Route53
* AWS Lambda
* SNS
* SQS
* CloudWatch

---




## Author

**Karthick C**

DevOps | Cloud Infrastructure | Terraform | AWS




