#!/bin/bash
# Normalize ENV Variables from Pipeline and Pipeline Variables
# v0.11
# AWS Edition

# These now come from the ENV
export TF_VAR_infra_name=$(echo "${INFRA_NAME}" | tr '[:upper:]' '[:lower:]')
echo TF_VAR_infra_name: ${TF_VAR_infra_name}

export TF_VAR_vm_name=$(echo "${VM_NAME}" | tr '[:upper:]' '[:lower:]')
echo TF_VAR_vm_name: ${TF_VAR_vm_name}
# ---------------

echo "Setting up variables for ENV_NAME: ${ENV_NAME}"
export TF_VAR_env_name=$(echo "${ENV_NAME}" | tr '[:upper:]' '[:lower:]')

# declare AWS_ACCESS_KEY_ID_VAR=${ENV_NAME}_AWS_ACCESS_KEY_ID
# export AWS_ACCESS_KEY_ID=${!AWS_ACCESS_KEY_ID_VAR}
# echo AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}

# declare AWS_SECRET_ACCESS_KEY_VAR=${ENV_NAME}_AWS_SECRET_ACCESS_KEY
# export AWS_SECRET_ACCESS_KEY=${!AWS_SECRET_ACCESS_KEY_VAR}
# echo AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}

export TF_VAR_aws_region=$AWS_REGION

STATE_SUFFIX=$(echo "${STATE_SUFFIX}" | tr '[:upper:]' '[:lower:]')
export TFSTATE_BUCKETNAME="${INFRA_NAME}-${TF_VAR_env_name}-${STATE_SUFFIX}"
export TF_VAR_tfstate_bucketname="${TFSTATE_BUCKETNAME}"

CIDR_BLOCK=$(echo "${CIDR_BLOCK}" | tr -d '[:space:]')
export TF_VAR_cidr_block="${CIDR_BLOCK}"
echo TF_VAR_cidr_block: ${TF_VAR_cidr_block}

OPS_IP1=$(echo "${OPS_IP1}" | tr -d '[:space:]')
export TF_VAR_ops_ip1="${OPS_IP1}"
echo TF_VAR_ops_ip1: ${TF_VAR_ops_ip1}

export TF_VAR_pubkey1="${PUBKEY1}"
echo TF_VAR_pubkey1: ${TF_VAR_pubkey1}

# check for provided VM_SIZE
if [ -n "${VM_SIZE}" ]; then
    VM_SIZE=$(echo "${VM_SIZE}" | tr -d '[:space:]')
    export TF_VAR_vm_size="${VM_SIZE}"
fi
echo TF_VAR_vm_size: ${TF_VAR_vm_size}
