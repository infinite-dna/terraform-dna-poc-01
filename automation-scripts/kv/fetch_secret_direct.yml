- name: Fetch secrets from Azure Key Vault using Ansible and Service Principal
  hosts: localhost
  gather_facts: no

  vars:
    vault_name: "<your-key-vault-name>"  # Replace with your Azure Key Vault name
    client_id: "<your-client-id>"  # Replace with the service principal client ID
    client_secret: "<your-client-secret>"  # Replace with the service principal secret
    tenant_id: "<your-tenant-id>"  # Replace with the tenant ID
    secrets_file: "/tmp/secrets.json"   # Temporary file to store secrets
    vm_secrets_path: "C:\\Temp\\secrets.ini"  # Path to upload secrets on the VM

  tasks:
    - name: Ensure Azure CLI is installed
      command: az --version
      register: azure_cli_check
      failed_when: azure_cli_check.rc != 0
      changed_when: false

    - name: Authenticate Azure CLI with Service Principal
      shell: >
        az login --service-principal
        --username "{{ client_id }}"
        --password "{{ client_secret }}"
        --tenant "{{ tenant_id }}"
      register: azure_login
      changed_when: false
      ignore_errors: no

    - name: Fetch secrets from Key Vault
      shell: |
        az keyvault secret list --vault-name "{{ vault_name }}" --query "[].{name:name}" -o json \
        | jq -r '.[] | .name' \
        | while read secret; do
            value=$(az keyvault secret show --vault-name "{{ vault_name }}" --name "$secret" --query "value" -o tsv);
            echo "$secret=$value" >> "{{ secrets_file }}";
          done
      args:
        executable: /bin/bash
      register: fetch_secrets
      changed_when: true

    - name: Debug fetched secrets
      debug:
        var: fetch_secrets.stdout_lines

    - name: Ensure the directory exists on the VM for the secrets file
      win_file:
        path: 'C:\\Temp'
        state: directory

    - name: Upload secrets file to the remote VM
      win_copy:
        src: "{{ secrets_file }}"
        dest: "{{ vm_secrets_path }}"

    - name: Cleanup local secrets file
      file:
        path: "{{ secrets_file }}"
        state: absent
