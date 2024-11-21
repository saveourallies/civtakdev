#!/bin/bash
# The Terraform Runner....
# v0.12

# Pass three input variables - env_type (e.g. d#ev or prod) and component name (e.g. role or ecr)
# if the third variable is apply or destroy it will run corresponding terraform action

# check requested folder (arg) matches current foldername
foldername=${PWD##*/}

if [ "$1" = "$foldername" ]; then
    echo "Executing Terraform and Infrastructure build scripts for $1 - component: $2"
    
    export COMPONENT="${2}"
    echo "Component: ${2}"
    echo "ENV_NAME: ${ENV_NAME}"

    # setup environment variables, INFRA_NAME, etc
    source ./env.sh
    
    # change to terraform component directory
    cd $COMPONENT
    
    # This terraform_runner used for Azure
    terraform init -reconfigure \
    -backend-config="resource_group_name=${TFSTATE_RG}" \
    -backend-config="storage_account_name=${TFSTATE_ACCOUNT}" \
    -backend-config="container_name=${TFSTATE_CONTAINER}" \
    -backend-config="key=${INFRA_NAME}/${COMPONENT}"

    # Use these for AWS deployments
    # -backend-config="region=${AWS_REGION}" \
    # -backend-config="bucket=${TFSTATE_BUCKETNAME}" \
    # -backend-config="key=${INFRA_NAME}/${COMPONENT}"
    
    echo "Workspace ENV_NAME: ${ENV_NAME}"

    # creates a workspace if it doesn't exist and selects it
    if ! terraform workspace select ${ENV_NAME}; then terraform workspace new ${ENV_NAME}; fi
    
    # execute Terraform plan/apply/destroy
    echo "Now terraform plan/apply/destroy"
    if [ "${3}" = "apply" ]; then
        terraform apply -auto-approve
    elif [ "${3}" = "destroy" ]; then
        terraform destroy -auto-approve
    else
        terraform plan
    fi

else
    echo "Foldername: ${foldername} should match component requested: ${1}"
fi
