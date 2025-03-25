# Hello World API Deployment on AWS ECS (EC2-backed)

## Overview

This project sets up a **Node Hello World API** and deploys it to **AWS ECS using EC2-backed instances**. The infrastructure is managed using **Terraform**, and the application is containerized with **Docker**.

## Features

- **Node API** serving a simple `Hello, World!` response.
- **Dockerized application** for easy container-based deployment.
- **AWS ECS with EC2 Instances** (not Fargate) for running tasks.
- **Elastic Load Balancer (ALB)** for external access.
- **Auto Scaling Group (ASG) and Launch Template** for ECS instances.
- **Terraform automation** for AWS setup and deployment.

---

## Project Structure

```
├── app
│   ├── app.js
│   ├── Dockerfile
│   ├── package.json
│   └── package-lock.json
├── infra
│   ├── backend.tf
│   ├── main.tf
│   ├── modules
│   │   ├── ecs
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── var.tf
│   │   ├── ecs-task
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── var.tf
│   │   ├── networks
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   └── var.tf
│   │   └── securitygroup
│   │       ├── mian.tf
│   │       ├── output.tf
│   │       └── var.tf
│   ├── niletask.tfvars
│   ├── provider.tf
│   └── var.tf
└── README.md

```

---

## Setup Instructions

### 1. Prerequisites

Ensure you have the following installed:

- **Docker**
- **AWS CLI** (authenticated with IAM permissions)
- **Terraform**

### 2. Clone the Repository

```sh
git clone https://github.com/your-repo/hello-world-api.git
cd hello-world-api
```
### 3. Edit values for Your Infra

```sh
cd infra
cp var.example  values.tfvars
```
### 4. Deploy Infrastructure with Terraform

```sh
terraform init
terraform apply -auto-approve -var-file values.tfvars
```

### 5. Verify Deployment

- Check ECS Cluster: `aws ecs list-container-instances --cluster your-cluster-name`

---

## Terraform Modules & Resources

### **Networking**

- VPC, Public Subnets
- Security Groups (ECS, ALB)

### **IAM Roles**

- ECS Task Execution Role
- EC2 Instance Profile for ECS

### **ECS Cluster & Instances**

- EC2-backed ECS cluster
- Auto Scaling Group & Launch Template

### **Load Balancer**

- Application Load Balancer (ALB) with Target Group

### **ECR & Task Definition**

- Private ECR repository
- ECS Task Definition
- ECS Service

### **Dockre**

- Build Docker image
- Push It To ECR

---

## API Endpoints

| Method | Endpoint | Description             |
| ------ | -------- | ----------------------- |
| GET    |    /     | Returns `Hello, World!` |

---



## Cleanup

To delete all resources:

```sh
cd infra
terraform destroy -auto-approve -var-file values.tfvars
```

