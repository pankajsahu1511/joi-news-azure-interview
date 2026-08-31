# JOI Interview Setup

This is a multi-step guide to deploy the JOI newsfeed application in Azure for a code pairing interview.

## JOI Application Overview

This project contains three services:

* `quotes` which serves a random quote from `quotes/resources/quotes.json`
* `newsfeed` which aggregates several RSS feeds together
* `front-end` which calls the two previous services and displays the results.

The services are provided as docker images. This README documents the steps to build the images and provision the infrastructure for the services.

## Deployment

### Prerequisites

These instructions are designed to work on a Mac or Linux OS, if you are running a Windows system then we recommend using WSL2 (Windows Subsystem for Linux) to ensure these instructions work on your system.

We recommend ensuring the following are installed on your system before proceeding:

* Make
* AZ CLI
* Docker

### Deployment Options

You have the following deployment options which you should choose from:

1. *Self Host*: You deploy the solution in your own Azure tenancy (which can be an Azure trial account) if you prefer to have full control of the resources and permissions. 
2. *TW Host*: You can leave it to the interviewer to deploy the solution into a ThoughtWorks Azure tenancy prior to the interview and then the interviewer will provide you with Azure credentials to access it.

#### Self Host Deployment

Export the below environment variable using the your last name (lowercase and without spaces) in your terminal and make sure CODE_PREFIX value should be less than 7 characters (if the surname is longer just exclude the extra characters). Exceeding this limit will cause an error, and the storage account creation will fail.

```sh
export CODE_PREFIX=<candidate_last>
```

Now run:
```sh
source randomize.sh && randomize
```

The output from this command should be ```Randomizing the code base...```. This should create interview_id.txt at the root of the repo and update all references of news4321 in the code base to news<CODE_PREFIX>. This ensures the resources created are unique.

##### Resource Deployment

You can run the following command which will deploy all the resources.

```sh
make deploy_interview
```

This will provision a new Azure resource group (e.g. news<CODE_PREFIX>_rg_joi_interview) and add all the relevant resources into it into your Azure subscription.

Once the command completes Terraform should print the output with URL of the front_end server, e.g.

```
Outputs:

frontend_url = http://34.244.219.156:8080
```

#### TW Host Deployment

##### Azure Credentials

Your interviewer should provide you with Azure credentials in the format similar to below.

```sh
export CODE_PREFIX=****
export ARM_CLIENT_ID=****
export ARM_CLIENT_SECRET=****
export ARM_TENANT_ID=****
export ARM_SUBSCRIPTION_ID=****
```

You can run these in your terminal to prepare your local environment to be ready to deploy to Azure.

##### Randomize solution with CODE_PREFIX

Now run:
```sh
source randomize.sh && randomize
```

The output from this command should be ```Randomizing the code base...```. This should create interview_id.txt at the root of the repo and update all references of news4321 in the code base to news<CODE_PREFIX>. This ensures the resources created are unique and helps to avoid resource conflicts.

##### Resource Deployment

The interviewer has already run the base deployment, *optionally* you can run the following commands once to ensure you can deploy from your system.

```sh
make base.infra
make az_login
make docker
make push
```

This will redeploy the container images into the container registries.

Any refactoring and redeployment of the application and it's immediate supporting infrastructure resources will require you to run the following commands:

```sh
make clean
make static
make deploy_site
make news.infra
```

Once the commands complete Terraform should print the output with URL of the front_end server, e.g.

```
Outputs:

frontend_url = http://34.244.219.156:8080
```

## Troubleshooting Windows Subsystem for Linux (WSL)

You need to be running WSL 2 or above.

### Randomize

Before you run randomize you need to remove the two '' after the 'sed -i ' because you're not running the command on a Mac therefore it won't work properly without this change.

### Make push

This didn't work in WSL but if needed you can do it manually. 

### Make news.infra

I had to change in infra/news/main.tf the 3 x VM SSH connection agent attribute to false for it to work.

## Solution Deletion / Clean Up Steps

### Delete services

To delete the deployment provisioned by terraform, run following command:

```sh
make news.deinfra
```

### Delete all the infra and the services

To delete all the infra provisioned by terraform, run following command:

```sh
make destroy_interview
```
