# Azure VM Deploy DocSet

## Overview

This project (AwsVmDeploy) uses Terraform to plan, deploy, and destory a Linux VM. This is setup to be run as a manual GitHub Actions Workflow.

![diagrams/structurizr-1-AzureVM.png](diagrams/structurizr-1-AzureVM.png)

Manually initiate the GitHub Action Workflow in the order below to build the VM.

1. an AWS (S3) storage account to store the Terraform state file
1. a virtual network (VPC) for hosting
1. a linux VM with a public IP address

![diagrams/structurizr-1-GitHub.png](diagrams/structurizr-1-GitHub.png)

### AWS Prep

Create a Service Account to run Terraform via GitHub Actions.

![diagrams/structurizr-1-AzureAD.png](diagrams/structurizr-1-AzureAD.png)

* [02_awsprep.md](02_awsprep.md)

### GitHub Prep

Numerous variables and a couple of secrets need to be setup in the GitHub environment (settings).

More Info: [03_githubprep](03_githubprep)

### Create TF State Storage

Deploy Terraform (TF) State Storage Account using the GitHub Action workflow.

* one secret: 
   * AWS_SECRET_ACCESS_KEY
* several variables: tenant, subsciption, location, etc.
   * AWS_ACCESS_KEY_ID
   * AWS_REGION
   * CIDR_BLOCK
   * OPS_IP1
   * PUBKEY1
   * STATE_SUFFIX
   * VM_SIZE

### Create Virtual Network

Run the GitHub Action workflow to create (apply) the Network (AWS VPC). Use a unique CIDR block for each environment to aid administration.

### Create Virtual Machine

Run the GitHub Actions Worfklow to create the new VM (Virtual Machine). Variables can be used to set VM Size, the source IP address for SSH connection from the administrator, and an Authorized SSH Public Key (a new authorized SSH Key-Pair is also created by the terraform).

The VM uses an Elastic (Public) IP Adress(EIP), a Network Security Group (NSG), and a Network Interface Card (NIC) to route, filter, and connect internet to the VM.
** check this

![diagrams/structurizr-1-AzureNetwork.png](diagrams/structurizr-1-AzureNetwork.png)

### Connect to the VM

Using the powers of SSH Keys, connect to the VM!
