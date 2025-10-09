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

%{ for acct in service_accounts ~}
  - name: "${acct.account_name}"
    gecos: "${acct.description}"
%{ if length(try(acct.sudo_permissions, [])) > 0 }
    sudo: "ALL=(ALL) NOPASSWD: ${join(",", acct.sudo_permissions)}"
%{ endif }
    shell: /bin/bash
%{ if startswith(acct.public_ssh_key, "gh:") }
    ssh_import_id:
      - ${acct.public_ssh_key}
%{ else }
    ssh_authorized_keys:
      - %{ if length(acct.allow_connections_from) > 0 ~}from="${join(",", acct.allow_connections_from)}" %{ endif ~}${acct.public_ssh_key}
%{ endif }
%{ endfor ~}

runcmd:
%{ for acct in service_accounts ~}
  - [ mkdir, -p, "/home/${acct.account_name}/.ssh" ]
  - [ chown, "-R", "${acct.account_name}:${acct.account_name}", "/home/${acct.account_name}/.ssh" ]
  - [ chmod, "700", "/home/${acct.account_name}/.ssh" ]
  - [ sh, -c, "test -f /home/${acct.account_name}/.ssh/authorized_keys && chmod 600 /home/${acct.account_name}/.ssh/authorized_keys || true" ]
%{ endfor ~}
