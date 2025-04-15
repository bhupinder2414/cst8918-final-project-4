# CST8918-Final-project-4
**Course: CST8918 - DevOps: Infrastructure as Code**

**Prof: Robert McKenney**
# CST8918 Final Project: Terraform, Azure AKS, and GitHub Actions

## Team Members
- **[Member 1 Name]** - (Bhupinder Singh)
- **[Member 2 Name]** - (Li Zhou)
- **[Member 3 Name]** - (Xi Jin)
- **[Member 4 Name]** - (Fattehali Sunasara)

## Project Overview
This project demonstrates Infrastructure as Code (IaC) using Terraform to deploy the Remix Weather Application on Azure Kubernetes Service (AKS) with a managed Redis DB for caching. The deployment is automated using GitHub Actions.

## Project Structure
```plaintext
cst8918-final-project/
│
├── remix-weather-app/               
├── terraform/
│   ├── backend/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── aks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── app/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── environments/
│   │   ├── dev/main.tf
│   │   ├── test/main.tf
│   │   └── prod/main.tf
│
├── .github/
│   └── workflows/
│       ├── static-analysis.yml
│       ├── plan-check.yml
│       ├── terraform-apply.yml
│       ├── docker-build.yml
│       └── deploy-app.yml
│
├── README.md
└── main.tf                           # Root Terraform entry point
```
## Project Architecture
![Project Architecture](Project.png)

## Prerequisites
- Azure account with sufficient permissions
- Terraform installed locally (for development)
- kubectl installed (for manual Kubernetes operations)
- Azure CLI installed (for manual Azure operations)

## Setup Instructions
1. Clone this repository
2. Set up Azure credentials for GitHub Actions (see below)
3. Create the Terraform backend storage account (first-time setup)
4. Create pull requests for changes and let GitHub Actions handle the deployment

### Azure Credentials Setup
1. Create an Azure AD application and service principal
2. Assign the necessary roles to the service principal
3. Add the following secrets to your GitHub repository:
   - AZURE_CLIENT_ID
   - AZURE_TENANT_ID
   - AZURE_SUBSCRIPTION_ID
   - AZURE_CREDENTIALS (JSON output of `az ad sp create-for-rbac`)

### First-Time Terraform Backend Setup
1. Navigate to `infrastructure/backend`
2. Run `terraform init`
3. Run `terraform apply`
4. Note the output values and configure them in your GitHub repository secrets:
   - STORAGE_ACCOUNT_NAME
   - CONTAINER_NAME
   - RESOURCE_GROUP_NAME
   - ACCESS_KEY

## Workflow Overview
1. Static analysis runs on every push
2. Terraform plan runs on PR to main (infrastructure changes)
3. Application build and test deployment runs on PR to main (app changes)
4. Terraform apply runs on merge to main (infrastructure changes)
5. Production deployment runs on merge to main (app changes)

## Screenshots
![GitHub Actions Workflows](workflows-screenshot.png)
