from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
import argparse
import json
import os

def fetch_secrets(vault_name, output_file):
    # Construct the Key Vault URL
    vault_url = f"https://{vault_name}.vault.azure.net"
    
    # Authenticate using DefaultAzureCredential
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=vault_url, credential=credential)
    
    # Fetch all secrets
    secrets = client.list_properties_of_secrets()
    secrets_data = {}
    
    for secret_property in secrets:
        secret = client.get_secret(secret_property.name)
        secrets_data[secret.name] = secret.value
    
    # Write secrets to output file
    with open(output_file, 'w') as f:
        json.dump(secrets_data, f, indent=2)
    print(f"Secrets written to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Fetch all secrets from an Azure Key Vault")
    parser.add_argument("--vault-name", required=True, help="Azure Key Vault name")
    parser.add_argument("--output", required=True, help="Output file for secrets")
    args = parser.parse_args()
    
    fetch_secrets(args.vault_name, args.output)
