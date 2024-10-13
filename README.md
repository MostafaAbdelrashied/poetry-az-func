# Azure Functions for Large-Scale Python Projects with Poetry

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Azure Functions](https://img.shields.io/badge/Azure%20Functions-Supported-blue)](https://azure.microsoft.com/en-us/services/functions/)
[![Poetry](https://img.shields.io/badge/Poetry-Package%20Manager-blue)](https://python-poetry.org/)
[![CI/CD Pipeline](https://github.com/MostafaAbdelrashied/poetry-az-func/actions/workflows/main.yml/badge.svg)](https://github.com/MostafaAbdelrashied/poetry-az-func/actions/workflows/main.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project demonstrates how to use Poetry as a package manager for Azure Functions Python projects. It showcases best practices for dependency management and project structure when developing Azure Functions with Python.

## Features

- **Azure Functions Project Structure**: Organized layout for scalable projects.
- **Poetry for Dependency Management**: Simplify managing dependencies and virtual environments.
- **Sample CRON Trigger Function**: Example of a time-triggered Azure Function.
- **GitHub Actions Workflow for CI/CD**: Automate testing and deployment with GitHub Actions.

## Prerequisites

- **Python 3.11**
- **[Poetry](https://python-poetry.org/docs/#installation)**
- **[Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli)**
- **[Azure Functions Core Tools](https://docs.microsoft.com/azure/azure-functions/functions-run-local#install-the-azure-functions-core-tools)**

### Azure Setup

Before deploying to Azure, you'll need to create a Function App:

```bash
az functionapp create \
  --resource-group <RESOURCE_GROUP> \
  --consumption-plan-location <LOCATION> \
  --runtime python \
  --functions-version 4 \
  --name <FUNCTION_APP_NAME> \
  --storage-account <STORAGE_ACCOUNT_NAME> \
  --os-type Linux
```

### GitHub Repository Configuration

For CI/CD, add the following variables to your GitHub repository settings:

- **Variables**:
  - `AZURE_FUNCTIONAPP_NAME`: Your Azure Function App name.
- **Secrets**:
  - `AZURE_FUNCTIONAPP_PUBLISH_PROFILE`: Your Azure Function App publish profile.

To retrieve the `AZURE_FUNCTIONAPP_PUBLISH_PROFILE`, run:

```bash
az functionapp deployment list-publishing-profiles \
  --name <FUNCTION_APP_NAME> \
  --resource-group <RESOURCE_GROUP> \
  --query "[?publishMethod=='MSDeploy'].value" \
  --output tsv
```

## Local Development

```bash
git clone https://github.com/MostafaAbdelrashied/poetry-az-func.git
cd poetry-az-func
poetry install --with dev
poetry shell
func start
```

## Project Structure

```bash
poetry-az-func
├── README.md
├── azure_functions # Azure Function triggers and configurations.
│   └── timeTrigger
│       ├── function_app.py
│       ├── host.json
│       └── local.settings.json
├── poetry.lock
├── pyproject.toml
├── ruff.toml
├── src # Core Python code for your application.
│   ├── __init__.py
│   ├── main.py
│   ├── data
│   ├── optimization
│   └── utils
└── tests
```