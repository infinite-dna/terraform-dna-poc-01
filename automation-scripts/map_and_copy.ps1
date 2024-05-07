---
- name: Copy data from mapped drive to local directory on Windows
  hosts: localhost
  connection: local
  become: yes
  become_method: runas
  become_user: 'Administrator'
  vars:
    # Source UNC path
    source_unc_path: "\\\\server\\share"
    
    # Destination path on the local system
    destination_path: "C:\\temp"
    
    # Mapped drive letter
    drive_letter: 'Z:'

    # Specify machine credentials for the source UNC path
    machine_username: "DOMAIN\\Username"
    machine_password: "Password"
  
  tasks:
    - name: Map network drive
      win_mount:
        path: "{{ drive_letter }}"
        src: "{{ source_unc_path }}"
        user: "{{ machine_username }}"
        password: "{{ machine_password }}"
        state: present
    
    - name: Copy files from mapped drive to local destination
      synchronize:
        src: "{{ drive_letter }}"
        dest: "{{ destination_path }}"
        recursive: yes
        mode: push
    
    - name: Unmap network drive
      win_mount:
        path: "{{ drive_letter }}"
        state: absent
 
