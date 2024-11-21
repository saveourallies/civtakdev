# AWS VM Deploy - DocSet

## GitHub Prep

### On GitHub Environments

Public GitHub repos and paid-for private repos can use Environments.

Free and private repo do not support Environments, but you need the workflow to accept the ENV_NAME as a Variable name, as it cannot be inherited from the environment.

### Setup each GitHub Environment

Access the repository Settings page to setup each environment variable and secret.

![github repo environments](images/github-repo-environments.png)

### Variables and Secrets

The following variables are needed to complete the workflow tasks (tfstate, network, vm).

| Variables          | Description               |
|--------------------|---------------------------|
| AWS_ACCESS_KEY_ID  |                           |
| AWS_REGION         |  AWS region name          |
| CIDR_BLOCK         | 10.x.0.0./20 - pick x     |
| OPS_IP1            | IP address got SSH        |
| PUBKEY1            | Public SSH Key to Connect |
| STATE_SUFFIX       | TF State Suffix           |
| VM_SIZE            | Azure VM size name        |

The following secrets are needed to complete the workflow tasks.

| Secret            | Description                                         |
|-------------------|-----------------------------------------------------|
| AWS_SECRET_ACCESS_KEY | password for Terraform service account          |

After the TF State account is created, retrieve a Key and add it as the secret: ARM_TFSTATE_KEY.

### Example of Environment Variables

The screenshot below shows the _variables_ setup for an environment in GitHub Settings.

![GitHub Environment Variables](images/github-environment-variables.png)
