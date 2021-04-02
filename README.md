# Setup Scripts for AML Workshop
Setup Scripts and Smoke Tests for Azure Machine Learning Workshops

> __NOTE:__ The ARM Template will now deploy Datastores and Datasets. No need to run CLI commands to attach these datastores or datasets.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Faml-workshops%2Fsetup%2Fmain%2Farm-templates%2Faml-workshop-deployment.json)


Steps to prepare for the workshop:
1. Deploy ARM template into a new Azure Resource Group. This can be done multiple ways:
    * Click the "Deploy to Azure" button above
    * Run CLI commands to deploy. See an example in the Makefile under 'deploy'
1. Ensure all workshop attendees have 'Contributor' (or similar) level access to the RG