# CIB Multi-Environment Provisioning for Azure Data Factory (ADF)

This repository contains infrastructure-as-code templates (Bicep) and environment-specific parameter files used to provision Azure Data Factory (ADF) resources across multiple environments (dev, UAT, prod) for the CIB project. The solution leverages GitHub Actions for CI/CD automation and securely manages sensitive credentials using Azure Key Vault and GitHub Secrets.

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

---

## Overview

This project automates the provisioning of Azure Data Factory resources using Bicep templates, ensuring a consistent and secure deployment across different environments. The key components of this solution include:

- **Bicep Templates:** Define the ADF instance, pipelines, datasets, linked services, integration runtimes, and triggers.
- **Parameter Files:** Environment-specific JSON files (in the `parameters/` folder) that provide non-sensitive configuration values.
- **CI/CD Pipeline:** A GitHub Actions workflow automates building, validating, and deploying the ADF resources.
- **Secrets Management:** Sensitive credentials are stored securely in Azure Key Vault and GitHub Secrets, ensuring they are not hardcoded.

[Back to Table of Contents](#table-of-contents)

---

## Repository Structure

```
cib-multi-env-provisioning/
│
├── ARMTemplateForFactory.bicep          # Main Bicep file for ADF deployment
├── ARMTemplateForFactory_backup.bicep     # Backup of the main Bicep file
├── Raw_to_ADLS.json                     # Legacy artifact (export/test output)
├── azure-pipelines.yml                  # (Optional) Azure DevOps pipeline YAML if used
├── parameters/
│   ├── dev.parameters.json              # Parameters for the development environment
│   ├── uat.parameters.json              # Parameters for the UAT environment
│   └── prod.parameters.json             # Parameters for the production environment
├── dependsOn.txt                        # Documentation of resource dependencies (if any)
├── resources.txt                        # Notes on resources defined by the templates
└── verify.ps1                           # PowerShell script for post-deployment verification
```

[Back to Table of Contents](#table-of-contents)

---

## Prerequisites

- **Azure Subscription:** An active Azure subscription (e.g., BPHC Dev/Test Subscription).
- **Azure CLI & Bicep CLI:** Ensure that you have the latest versions installed.
- **Azure Key Vault:** A configured Key Vault (e.g., `dmi-dev-keyvault` in the DMI-Dev resource group) containing secrets such as:
  - `SqlServerDMBPHCETO-password`
  - `SqlServerETO-password`
  - `SharePointOnlineList-SP-key`
- **GitHub Repository:** This repository is hosted on GitHub at [https://github.com/bphc-tech/cib-multi-env-provisioning](https://github.com/bphc-tech/cib-multi-env-provisioning).
- **CI/CD Credentials:** Azure service principal credentials stored securely as GitHub Secrets (e.g., `AZURE_CREDENTIALS_DEV` and `AZURE_CREDENTIALS_PROD`).

[Back to Table of Contents](#table-of-contents)

---

## Deployment Instructions

### Local Deployment

1. **Build the Bicep Template:**
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
   > **Note:** In an automated environment, the SharePoint key should be injected using CI/CD secure variables.

[Back to Table of Contents](#table-of-contents)

### CI/CD Deployment with GitHub Actions

1. **Workflow Configuration:**
   The GitHub Actions workflow is defined in `.github/workflows/azure-deploy.yml`. It dynamically selects the appropriate parameter file and credentials based on the branch:
   - **DEV/UAT:** Uses `AZURE_CREDENTIALS_DEV` and `parameters/dev.parameters.json`.
   - **PROD:** Uses `AZURE_CREDENTIALS_PROD` and `parameters/prod.parameters.json`.
2. **Set Up GitHub Secrets:**
   - **AZURE_CREDENTIALS_DEV:** Contains the DEV service principal credentials in JSON.
   - **AZURE_CREDENTIALS_PROD:** Contains the production service principal credentials in JSON.
   - **SPKey:** Contains the SharePoint service principal key.
3. **Trigger the Deployment:**
   Commit and push your changes. The workflow triggers automatically based on branch events (push or pull request) to `dev`, `main`, or `prod`.

[Back to Table of Contents](#table-of-contents)

---

## Security & Secrets Management

- **Azure Key Vault Integration:**  
  Sensitive data such as SQL passwords and the SharePoint key are stored in Azure Key Vault and referenced by the Bicep templates.
- **CI/CD Secrets:**  
  The Azure service principal credentials and SharePoint key are stored as GitHub Secrets (`AZURE_CREDENTIALS_DEV`, `AZURE_CREDENTIALS_PROD`, and `SPKey`), ensuring secure and auditable deployments.

[Back to Table of Contents](#table-of-contents)

---

## Troubleshooting

- **Deployment Errors:**  
  If deployments fail, use the following commands to review error details:
  ```powershell
  az deployment group list --resource-group cib-demo-dev --output table
  az deployment group show --resource-group cib-demo-dev --name <deploymentName>
  ```
- **Pipeline Logs:**  
  Check the GitHub Actions logs for detailed error messages and debugging information.

[Back to Table of Contents](#table-of-contents)

---

## Contributing

Contributions are welcome! If you have suggestions, bug fixes, or improvements, please open an issue or submit a pull request. Make sure to follow the repository guidelines and include tests when applicable.

[Back to Table of Contents](#table-of-contents)

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

[Back to Table of Contents](#table-of-contents)
```

### Next Steps

1. **To Replace the Existing README:**
   - Open the existing README file for editing:
     ```powershell
     notepad README.md
     ```
2. **Replace the Content:**  
   Paste the improved version above over the existing content.
3. **Save and Commit:**  
   Save the changes, then add, commit, and push the updated README:
   ```powershell
   git add README.md
   git commit -m "Improve README with detailed table of contents and updated instructions"
   git push origin dev
   ```
