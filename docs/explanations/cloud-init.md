# cloud-init

The cloud-init script is executed once after finishing the OS installation; it can be used to execute an initial
configuration, like ensuring the presence of certain users, SSH keys or packages. If the cloud-init script does not
perform any relevant changes, the server becomes available with the SSH key from the MAAS profile and the username
`ubuntu`.
