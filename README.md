# Azure Functions for large scale python projects with Poetry

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![Azure Functions](https://img.shields.io/badge/Azure%20Functions-Supported-blue)](https://azure.microsoft.com/en-us/services/functions/)
[![Poetry](https://img.shields.io/badge/Poetry-Package%20Manager-blue)](https://python-poetry.org/)
[![CI/CD Pipeline](https://github.com/MostafaAbdelrashied/poetry-az-func/actions/workflows/main.yml/badge.svg)](https://github.com/MostafaAbdelrashied/poetry-az-func/actions/workflows/main.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This project demonstrates how to use Poetry as a package manager for Azure Functions Python projects. It showcases best practices for dependency management and project structure when developing Azure Functions with Python.

## Features

- Azure Functions project structure
- Poetry for dependency management
- Sample CRON trigger function
- GitHub Actions workflow for CI/CD

## Prerequisites

- Python 3.11
- [Poetry](https://python-poetry.org/docs/#installation)
- [Azure Functions Core Tools](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#install-the-azure-functions-core-tools)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (for deployment)
- Azure Function App (for deployment) "az functionapp create --resource-group MyGroup --consumption-plan-location germanywestcentral --runtime python --functions-version 4 --name MyFunction --storage-account MyStorage --os-type Linux"
- Adding to your environment 
  - [vars] AZURE_FUNCTIONAPP_NAME:
  - [secrets] AZURE_FUNCTIONAPP_PUBLISH_PROFILE:

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/MostafaAbdelrashied/poetry-az-func.git
   cd poetry-az-func
   ```

2. Install dependencies using Poetry:
   ```bash
   poetry install --with dev
   ```

## Local Development

1. Activate the Poetry virtual environment:
   ```bash
   poetry shell
   ```

2. Start the function app locally:
   ```bash
   func start
   ```

## Project Structure

```
poetry-az-func
├── README.md
├── azure_functions
│   └── timeTrigger
│       ├── function_app.py
│       ├── host.json
│       └── local.settings.json
├── poetry.lock
├── pyproject.toml
├── ruff.toml
├── src
│   ├── __init__.py
│   ├── main.py
│   ├── data
│   │   └── __init__.py
│   ├── optimization
│   │   ├── __init__.py
│   │   └── objective.py
│   └── utils
│       ├── __init__.py
│       ├── args_parser.py
│       └── logging.py
└── tests
    ├── __init__.py
    └── test_main.py
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


## Acknowledgements

- [Azure Functions Python Developer Guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-reference-python)
- [Poetry Documentation](https://python-poetry.org/docs/)