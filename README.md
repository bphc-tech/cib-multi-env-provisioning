# CIB Multi-Environment Provisioning for Azure Data Factory (ADF)

This repository contains infrastructure-as-code templates (Bicep) and parameter files used to provision Azure Data Factory (ADF) resources across multiple environments (dev, UAT, prod) for the CIB project.

## Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Deployment Instructions](#deployment-instructions)
  - [Local Deployment](#local-deployment)
  - [CI/CD Deployment with GitHub Actions](#ci-cd-deployment-with-github-actions)
- [Security & Secrets Management](#security--secrets-management)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

This project automates the provisioning of Azure Data Factory resources using Bicep templates. The goal is to deploy a consistent ADF setup across multiple environments, ensuring that all sensitive credentials are managed securely via Azure Key Vault and using managed identities wherever possible.

Key components include:
- **Bicep Templates:** Define the Data Factory instance, pipelines (e.g., `Raw_to_ADLS`, `ADLS_Raw_To_ADLS_Processed`), datasets, linked services, integration runtimes, and triggers.
- **Parameter Files:** Environment-specific JSON files (located under the `parameters/` folder) that supply non-sensitive configuration values.
- **CI/CD Pipeline:** GitHub Actions workflow that automates building, validating, and deploying the infrastructure.

## Repository Structure

```
cib-multi-env-provisioning/
│
├── ARMTemplateForFactory.bicep    # Main Bicep file for ADF deployment
├── ARMTemplateForFactory_backup.bicep
├── Raw_to_ADLS.json               # Legacy artifact (export/test output)
├── azure-pipelines.yml            # (Optional) Azure DevOps pipeline YAML if used
├── parameters/
│   ├── dev.parameters.json        # Parameters for development environment
│   ├── uat.parameters.json        # Parameters for UAT environment
│   └── prod.parameters.json       # Parameters for Production environment
├── dependsOn.txt                  # Documentation of resource dependencies (if any)
├── resources.txt                  # Notes on resources created by the templates
└── verify.ps1                     # PowerShell script for post-deployment verification
```

## Prerequisites

- **Azure Subscription:** Access to an Azure subscription (e.g., BPHC Dev/Test Subscription).
- **Azure CLI and Bicep CLI:** Ensure you have the latest Azure CLI and Bicep installed.
- **Key Vault:** A configured Azure Key Vault (e.g., `dmi-dev-keyvault` in the `DMI-Dev` resource group) with required secrets:
  - `SqlServerDMBPHCETO-password`
  - `SqlServerETO-password`
  - `SharePointOnlineList-SP-key`
- **GitHub Repository:** This repository is hosted on GitHub at [https://github.com/bphc-tech/cib-multi-env-provisioning](https://github.com/bphc-tech/cib-multi-env-provisioning).
- **CI/CD Credentials:** A service principal with sufficient permissions to deploy resources (stored securely as GitHub Secrets).

## Deployment Instructions

### Local Deployment

1. **Build the Bicep File:**
   ```powershell
   az bicep build --file ARMTemplateForFactory.bicep
   ```
2. **Create the Resource Group (if not already existing):**
   ```powershell
   az group create --name cib-demo-dev --location "East US"
   ```
3. **Deploy the Template:**
   ```powershell
   az deployment group create --mode Complete --resource-group cib-demo-dev --template-file ARMTemplateForFactory.bicep --parameters @parameters/dev.parameters.json --parameters SharePointOnlineList_Jan28_servicePrincipalKey=<your-SP-key>
   ```
   > **Note:** For full automation, the SharePoint key should be injected via CI/CD secure variables.

### CI/CD Deployment with GitHub Actions

1. **Create a Workflow File:**  
   In the repository, create `.github/workflows/azure-deploy.yml` with content similar to:
   ```yaml
   name: Azure Deployment

   on:
     push:
       branches: [ main ]
     pull_request:
       branches: [ main ]

   jobs:
     deploy:
       runs-on: ubuntu-latest
       steps:
         - name: Checkout Code
           uses: actions/checkout@v2

         - name: Set up Azure CLI
           uses: azure/CLI@v1
           with:
             azcliversion: '2.40.0'

         - name: Azure Login
           uses: azure/login@v1
           with:
             creds: ${{ secrets.AZURE_CREDENTIALS }}

         - name: Build Bicep Template
           run: |
             az bicep build --file ARMTemplateForFactory.bicep

         - name: Create Resource Group if not exists
           run: |
             az group create --name cib-demo-dev --location "East US"

         - name: Deploy Bicep Template
           run: |
             az deployment group create --mode Complete --resource-group cib-demo-dev --template-file ARMTemplateForFactory.bicep --parameters @parameters/dev.parameters.json --parameters SharePointOnlineList_Jan28_servicePrincipalKey=${{ secrets.SPKey }}
   ```
2. **Set Up GitHub Secrets:**  
   In your GitHub repository settings under **Secrets and variables > Actions**:
   - **AZURE_CREDENTIALS:** A JSON string with your service principal credentials.
   - **SPKey:** The SharePoint service principal key.

3. **Commit and Push the Workflow:**
   ```powershell
   git add .github/workflows/azure-deploy.yml
   git commit -m "Add GitHub Actions workflow for automated deployment"
   git push
   ```
4. **Monitor the Pipeline:**  
   Check the Actions tab in GitHub to verify that the deployment runs successfully.

## Security & Secrets Management

- **Key Vault Integration:**  
  Sensitive credentials (SQL passwords, SharePoint key) are stored in Azure Key Vault and referenced in the Bicep file.
- **CI/CD Secrets:**  
  Azure service principal credentials are stored as GitHub Secrets (`AZURE_CREDENTIALS`), and the SharePoint key is passed as a secure variable (`SPKey`).

## Troubleshooting

- **Hardcoded URL Warnings:**  
  Warnings about hardcoded URLs (e.g., "core.windows.net") can be addressed later using the `environment()` function.
- **Deployment Errors:**  
  Use:
  ```powershell
  az deployment group list --resource-group cib-demo-dev --output table
  az deployment group show --resource-group cib-demo-dev --name <deploymentName>
  ```
  to view error details.
- **Pipeline Logs:**  
  Check GitHub Actions logs for detailed information if the deployment fails.

## Contributing

Feel free to open issues or pull requests with improvements or bug fixes. Please follow our coding standards and include tests when possible.
