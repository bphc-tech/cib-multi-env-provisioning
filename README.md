# cib-multi-env-provisioning

**cib-multi-env-provisioning** is an Azure resource provisioning project that uses Bicep templates and ARM parameters. The project is managed in Git and employs GitHub Actions for continuous integration and continuous deployment (CI/CD).

## Overview

This project provisions Azure resources (such as Data Factory, networking, and DNS zones) using modularized Bicep templates. It supports multiple environments (development, UAT, and production) through branch-based deployments and parameter files. The deployment process is automated via GitHub Actions, which uses service principal credentials stored securely as GitHub secrets.

## Project Structure

- **.github/workflows/azure-deploy.yml**  
  This workflow file triggers deployments on push, pull requests, or manual triggers (workflow_dispatch) for specific branches (e.g., dev, uat, and main).

- **parameters/**  
  Contains JSON parameter files for each environment. For production, the file is typically named `prod.parameters.json` and contains production-specific resource names, IDs, and configuration values.

- **templates/**  
  - **ARMTemplateForFactory.bicep**  
    The main Bicep file that orchestrates the deployment of factory resources.
  - **modules/**  
    Contains modular Bicep files (e.g., `network.bicep`) for provisioning specific sets of resources like networking and DNS. This approach promotes reusability and cleaner code organization.

## Environments & Branches

- **Production (main branch):**  
  Deployments to production occur on the main branch and target the **CIB-DL-PROD** resource group in the **BPHC Dev/Test Subscription**.

- **UAT (uat branch):**  
  Deployments to the UAT environment target a separate resource group (e.g., **CIB-DL-UAT**) with corresponding parameters.

- **Development (dev branch):**  
  Optionally, a dev branch may be used for integration testing or additional development.

## Deployment Process

1. **GitHub Actions Workflow:**  
   - The deployment workflow (`azure-deploy.yml`) is triggered by push events, pull requests, or manually using the workflow_dispatch event.
   - The workflow logs into Azure using a service principal whose credentials are stored in GitHub secrets (e.g., `AZURE_CREDENTIALS_PROD` for production).

2. **Bicep Template Build & Deployment:**  
   - The main Bicep template (`ARMTemplateForFactory.bicep`) is built and validated using the Azure CLI.
   - The deployment is executed using `az deployment group create` command, which deploys the template to the target resource group (e.g., **CIB-DL-PROD**) using the appropriate parameter file (e.g., `prod.parameters.json`).

3. **Resource Provisioning:**  
   - The deployment creates and configures resources such as Data Factory instances, networking components (public IPs, local network gateways, route tables), and private DNS zones.
   - The modularized approach ensures that each resource set is maintained in its dedicated module (e.g., the network module).

## Usage

### Local Validation

You can validate your Bicep templates locally using the Azure CLI:

```bash
az bicep build --file templates/ARMTemplateForFactory.bicep
az bicep lint --file templates/ARMTemplateForFactory.bicep
```

### Triggering a Deployment

Since deployments are managed through GitHub Actions, simply push your changes to the respective branch (e.g., `main` for production). You can also trigger the workflow manually using the GitHub Actions interface if needed.

### Checking Deployment Status

You can check the deployment status via the CLI:

```bash
az deployment group list --resource-group CIB-DL-PROD --output table
```

Or, view detailed deployment information with:

```bash
az deployment group show --resource-group CIB-DL-PROD --name ARMTemplateForFactory
```

## Troubleshooting

- **Role & Permissions:**  
  Ensure that the service principal used in GitHub Actions has the necessary permissions in the target subscription. In production, the elevated account should have at least Reader access (or higher if needed) on the resource group.

- **Quota Issues:**  
  Monitor Azure resource quotas (e.g., Public IP limits). If quota errors occur, consider cleaning up unused resources or requesting a quota increase.

- **Deployment Errors:**  
  Use the Azure CLI and GitHub Actions logs to identify any deployment issues. Validate your parameter files to ensure consistency between the Bicep templates and the values provided.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions or improvements. Please ensure that no sensitive information (e.g., client secrets or subscription IDs) is included in your submissions.

