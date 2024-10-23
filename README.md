# Azure Functions with Poetry

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Azure Functions](https://img.shields.io/badge/Azure%20Functions-Supported-blue)](https://azure.microsoft.com/en-us/services/functions/)
[![Poetry](https://img.shields.io/badge/Poetry-Package%20Manager-blue)](https://python-poetry.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[![Dev](https://img.shields.io/github/actions/workflow/status/MostafaAbdelrashied/poetry-az-func/main.yml?branch=dev&label=Dev)](https://github.com/MostafaAbdelrashied/poetry-az-func/actions?query=workflow%3ACI%2FCD+branch%3Adev)
[![Staging](https://img.shields.io/github/actions/workflow/status/MostafaAbdelrashied/poetry-az-func/main.yml?branch=staging&label=Staging)](https://github.com/MostafaAbdelrashied/poetry-az-func/actions?query=workflow%3ACI%2FCD+branch%3Astaging)
[![Production](https://img.shields.io/github/actions/workflow/status/MostafaAbdelrashied/poetry-az-func/main.yml?branch=main&label=Production)](https://github.com/MostafaAbdelrashied/poetry-az-func/actions?query=workflow%3ACI%2FCD+branch%3Amain)

This project demonstrates how to use Poetry as a package manager for Azure Functions. It is production-ready and can be used as a template for your next project. It includes a sample time-triggered Azure Function and a GitHub Actions workflow for CI/CD for automated testing and deployment **across multiple environments** (`dev`, `staging`, `prod`).

## Features

- **Multi-Environment Deployment**: Deploy to development, staging, and production environments using separate branches.
- **Automated CI/CD Pipeline**: Continuous integration and deployment using GitHub Actions.
- **Dependency Management**: Managed with Poetry for consistent environments.
- **Azure Functions Support**: Build serverless applications with ease.

## Prerequisites

- **Python 3.11**
- **[Poetry](https://python-poetry.org/docs/#installation)**
- **[Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)**
- **[Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools)**

## Environments and Deployment Strategy

This project utilizes a branching strategy where each branch corresponds to a specific deployment environment:

- **`dev` Branch**: Deploys to the **Development** environment.
- **`staging` Branch**: Deploys to the **Staging** environment.
- **`main` Branch**: Deploys to the **Production** environment.

When changes are pushed or merged into these branches, the GitHub Actions workflows automatically trigger the CI/CD pipeline to build, test, and deploy the application to the respective Azure Function App associated with each environment.

### CI/CD Pipeline Overview

- **Continuous Integration (CI)**:
  - Triggered on every push and pull request to `dev`, `staging`, or `main`.
  - Runs linting, testing, and code analysis.
- **Continuous Deployment (CD)**:
  - Initiated after successful CI checks.
  - Deploys the code to the corresponding Azure Function App environment.

## Azure Setup

Before deploying to Azure, you'll need to set up separate Function Apps for each environment.

### Create Resource Groups and Function Apps

Ensure you have resource groups and function apps for `dev`, `staging`, and `prod` environments.

```bash
# Set variables for each environment
ENVIRONMENTS=("dev" "staging" "prod")
LOCATION="<YOUR_AZURE_REGION>"

for ENV in "${ENVIRONMENTS[@]}"; do
  RESOURCE_GROUP="my-project-rg-$ENV"
  FUNCTION_APP_NAME="my-function-app-$ENV"
  STORAGE_ACCOUNT_NAME="mystorageaccount$ENV"

  # Create Resource Group
  az group create --name $RESOURCE_GROUP --location $LOCATION

  # Create Storage Account
  az storage account create --name $STORAGE_ACCOUNT_NAME --location $LOCATION \
    --resource-group $RESOURCE_GROUP --sku Standard_LRS

  # Create Function App
  az functionapp create \
    --resource-group $RESOURCE_GROUP \
    --consumption-plan-location $LOCATION \
    --runtime python \
    --functions-version 4 \
    --name $FUNCTION_APP_NAME \
    --storage-account $STORAGE_ACCOUNT_NAME \
    --os-type Linux
done
```

### Obtain Azure Credentials

Retrieve the necessary credentials for Azure login and deployment.

```bash
# Get Azure Subscription ID
SUBSCRIPTION_ID=$(az account show --query 'id' -o tsv)

# Get Tenant ID
TENANT_ID=$(az account show --query 'tenantId' -o tsv)

# Create a Service Principal for authentication
az ad sp create-for-rbac --name "my-function-app-sp" --role contributor \
    --scopes /subscriptions/$SUBSCRIPTION_ID \
    --sdk-auth
```

*Note:* Save the output, which includes the `clientId`, `clientSecret`, `subscriptionId`, and `tenantId`.

## GitHub Repository Configuration

For the CI/CD pipeline to deploy to each environment appropriately, configure your GitHub repository settings as follows.

### Create GitHub Environments

In your GitHub repository, create the following environments:

- **`dev`**
- **`staging`**
- **`prod`**

### Add Environment Secrets

For each environment, add the following **Secrets**:

- `AZURE_CLIENT_ID` - The `clientId` from the service principal.
- `AZURE_CLIENT_SECRET` - The `clientSecret` from the service principal.
- `AZURE_TENANT_ID` - The `tenantId` from your Azure account.
- `AZURE_SUBSCRIPTION_ID` - Your Azure subscription ID.
- `AZURE_FUNCTIONAPP_NAME` - The name of the Azure Function App for the environment.
- `RESOURCE_GROUP` - The resource group name for the environment.
- `AZURE_STORAGE_CONNECTION_STRING` - The connection string of the storage account.

### Set Up GitHub Actions Workflows

The CI/CD workflows are defined in the `.github/workflows` directory. They are configured to use the secrets depending on the environment.

- The `CI` workflow runs tests and linting.
- The `CD` workflow deploys the application to the appropriate Azure Function App.

## Local Development

You can develop and test the Azure Function locally before deploying.

```bash
# Clone the repository
git clone https://github.com/MostafaAbdelrashied/poetry-az-func.git
cd poetry-az-func

# Install dependencies with Poetry
poetry install --with dev

# Activate the virtual environment
poetry shell

# Start the Azure Function locally
func start
```

## Project Structure

```bash
poetry-az-func
├── README.md
├── function_app.py          # Main entry point for the Azure Function
├── host.json                # Azure Functions host configuration
├── local.settings.json      # Local settings for development
├── poetry.lock              # Locked dependencies
├── pyproject.toml           # Project configuration and dependencies
├── ruff.toml                # Configuration for the Ruff linter
├── src                      # Core Python package
│   ├── __init__.py
│   ├── data                 # Data-related modules
│   │   └── __init__.py
│   ├── main.py              # Main application logic
│   ├── optimization         # Optimization modules
│   │   ├── __init__.py
│   │   └── objective.py
│   └── utils                # Utility modules
│       ├── __init__.py
│       ├── args_parser.py
│       └── logging.py
└── tests                    # Unit tests
    ├── __init__.py
    └── test_main.py
```