#cloud-config
users:
  - default
  - name: ${admin_user_name}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
%{ if startswith(admin_public_ssh_key, "gh:") }
    ssh_import_id:
      - ${admin_public_ssh_key}
%{ else }
    ssh_authorized_keys:
      - ${admin_public_ssh_key}
%{ endif }
