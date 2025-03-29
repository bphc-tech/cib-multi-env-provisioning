```markdown
# cib-multi-env-provisioning

**cib-multi-env-provisioning** is an Azure resource provisioning project that uses Bicep templates and ARM parameters. The project is managed in Git and employs GitHub Actions for continuous integration and continuous deployment (CI/CD).

## Overview

This project provisions Azure resources (such as Data Factory, networking, and DNS zones) using modularized Bicep templates. It supports multiple environments (development, UAT, and production) through branch-based deployments and parameter files. The deployment process is automated via GitHub Actions, which uses service principal credentials stored securely as GitHub secrets.

## Project Structure

- **.github/workflows/azure-deploy.yml**  
  This workflow file triggers deployments on push, pull request, and manual (workflow_dispatch) events for specific branches (e.g., dev, uat, and main). It sets environment variables to select the appropriate resource group and parameter file.

- **parameters/**  
  Contains JSON parameter files for each environment:
  - `prod.parameters.json` for production deployments.
  - `uat.parameters.json` for UAT deployments.
  
  *Note:* There is no separate `dev.parameters.json` because the dev branch is used only for testing changes. Deployments from the dev branch use the UAT parameter file.

- **templates/**  
  - **ARMTemplateForFactory.bicep**  
    The main Bicep template that orchestrates the deployment of factory resources.
  - **modules/**  
    Contains modular Bicep files (e.g., `network.bicep`) for provisioning specific resource sets such as networking, DNS zones, virtual networks, etc. This modular approach promotes reusability and simplifies maintenance.

## Environments & Branches

- **Production (main branch):**  
  - Deploys to the **CIB-DL-PROD** resource group.
  - Uses `parameters/prod.parameters.json`.
  - Uses production service principal credentials (`AZURE_CREDENTIALS_PROD`).

- **UAT (uat branch):**  
  - Deploys to the **CIB-DL-UAT** resource group.
  - Uses `parameters/uat.parameters.json`.
  - Uses UAT service principal credentials (`AZURE_CREDENTIALS_DEV`).

- **Development (dev branch):**  
  - The dev branch is used for testing changes.
  - Deployments from dev branch also use UAT configuration (i.e. **CIB-DL-UAT** resource group and `parameters/uat.parameters.json`) to ensure changes are validated in a non-production environment.
  - If a separate development environment is later needed, you can create a dedicated parameter file (e.g., `dev.parameters.json`), update the GitHub Actions workflow, and use a separate resource group.

## Deployment Process

1. **GitHub Actions Workflow:**  
   The workflow (`azure-deploy.yml`) is triggered automatically on push or pull request events. It sets environment variables based on the branch:
   - **main:** Uses production settings.
   - **uat** or **dev:** Uses UAT settings.
   
2. **Bicep Template Build & Deployment:**  
   - The main template (`ARMTemplateForFactory.bicep`) is built and validated locally using the Azure CLI.
   - Deployment is executed via the `az deployment group create` command. The correct parameter file is passed based on the branch (e.g., `prod.parameters.json` for main, and `uat.parameters.json` for uat or dev).

3. **Resource Provisioning:**  
   The deployment provisions and configures resources such as Data Factory, networking components (public IP, local network gateway, virtual network, virtual network gateway, etc.), and DNS zones.  
   - The networking resources are grouped into an extended module (`modules/network.bicep`), which centralizes network configurations.
   - The VPN connection block in the networking module is currently disabled (commented out) due to the missing shared key. Once the key is provided by the administrator, you can uncomment and update that block.

## Local Validation & Deployment

- **Validating the Bicep Templates:**

  ```bash
  az bicep build --file templates/ARMTemplateForFactory.bicep
  az bicep lint --file templates/ARMTemplateForFactory.bicep
  ```

- **Triggering a Deployment:**
  - Push changes to the appropriate branch (main, uat, or dev).
  - The GitHub Actions workflow will trigger a deployment.
  - You can monitor the deployment in the [Actions tab](https://github.com/bphc-tech/cib-multi-env-provisioning/actions) or via the Azure CLI:

    ```bash
    az deployment group list --resource-group CIB-DL-PROD --output table
    az deployment group show --resource-group CIB-DL-PROD --name ARMTemplateForFactory
    ```

## Troubleshooting

- **Role & Permissions:**  
  Ensure the service principal used in the workflow has sufficient permissions in the target subscription.
  
- **Parameter File Consistency:**  
  Verify that the parameter file referenced in the workflow (e.g., `uat.parameters.json`) exists and matches the environment settings.

- **Shared Key for VPN:**  
  The VPN connection block is currently disabled. When you receive the shared key, update the block in the networking module and re-enable it.

## Contributing

Feel free to open issues or submit pull requests if you have suggestions or improvements. Please ensure that no sensitive information (e.g., client secrets or subscription IDs) is included in your submissions.

---

This revised README should help your team understand the deployment strategy, branch mappings, and how to modify the environment if a separate development environment is desired. Let me know if any additional details are needed or if further modifications are required.
```

---

Feel free to open the README file in Notepad using:

```powershell
notepad README.md
```

and then modify it as needed.