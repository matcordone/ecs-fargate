# 🚀 ECS Fargate Deployment with Terraform & GitHub Actions

This project automates the deployment of a Dockerized app on **AWS ECS Fargate** using **Terraform** and **GitHub Actions** for CI/CD.

---

## 🛠️ What It Does

- 🧱 Provisions complete infrastructure:
  - Custom VPC with public and private subnets
  - Internet Gateway + NAT Gateway
  - Application Load Balancer (ALB)
  - ECS Fargate Cluster & Service
  - IAM roles and policies
  - Auto Scaling for ECS tasks
  - Remote S3 backend for Terraform state

- 🌐 Hosts a simple `Hello World` Nginx web app.

- ⚙️ Automatically builds and deploys new images via GitHub Actions.

---

## 📦 Infrastructure Overview

All infrastructure is deployed in **`us-east-1`** and includes:

- ✅ VPC with proper routing and NAT
- ✅ ALB + Listener + Target Group
- ✅ ECS Cluster + Service
- ✅ ECR Repository
- ✅ Task definition with Fargate compatibility
- ✅ Auto Scaling Policies
- ✅ S3 backend for state management

---

## 🤖 GitHub Actions Workflow

The CI/CD pipeline includes:

1. **Trigger:** On push to `app/index.html` or `Dockerfile`
2. **Build:** Docker image is built and tagged
3. **Push:** Image is pushed to Amazon ECR
4. **Deploy:** ECS Task Definition is updated
5. **Update:** ECS Service is force-deployed with the new task

Everything is secure with **OIDC (OpenID Connect)** and GitHub credentials.

---

## 📈 Auto Scaling

ECS tasks scale automatically based on CPU:

- 🔼 Scales **up** when average CPU > `50%`
- 🔽 Scales **down** after cooldown if load drops

## 🔐 Security & Access

Uses OIDC for secure GitHub-to-AWS authentication.

ECS task role has permission for:

Accessing ECR

Writing logs to CloudWatch

SSM session manager support for manual container access

## 🧪 How to Stress Test It
SSH into a task using SSM Session Manager

Run a CPU stress script like:

```#!/bin/sh
while true; do echo "burning CPU..."; done
```

## 🌍 Final Notes
This repo was created for learning and testing purposes with low-cost infrastructure on AWS.
ECS Fargate + Terraform + GitHub Actions = 🔥

