#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Variables
VAULT_NAME="<your-key-vault-name>"  # Replace with your Key Vault name
PYTHON_SCRIPT_PATH="/path/to/fetch_all_secrets.py"  # Update to the actual path
SECRETS_FILE="/tmp/secrets.json"
ANSIBLE_PLAYBOOK_PATH="/path/to/fetch_secrets_playbook.yml"  # Update to the actual path
WORKING_DIR="/tmp/ansible_$(date +%Y%m%d%H%M%S)"

# Create a working directory
mkdir -p "$WORKING_DIR"

# Step 1: Ensure Python dependencies are installed
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Installing Python dependencies"
pip3 install azure-identity azure-keyvault-secrets

# Step 2: Run the Python script to fetch secrets
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Running Python script to fetch secrets"
python3 "$PYTHON_SCRIPT_PATH" --vault-name "$VAULT_NAME" --output "$SECRETS_FILE"

# Step 3: Run the Ansible playbook
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Running Ansible playbook"
ansible-playbook "$ANSIBLE_PLAYBOOK_PATH" -e "vault_name=$VAULT_NAME secrets_file=$SECRETS_FILE"

# Step 4: Cleanup
echo "[$(date +'%Y-%m-%d %H:%M:%S')] Cleaning up"
rm -rf "$WORKING_DIR"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Script completed successfully"
