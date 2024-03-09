# How to use ansible _with_ vault values:

`asnbile-playbook install_common.yml --ask-vault-pass`

# How to use ansible _without_ vault values:

`asnbile-playbook install_common.yml`

# Add ansible secret vault for using _password_ and other _sencetive_ values:

Command for creating secret file for storing values:
`ansible-vault create secret_vars_common.yml`

-   then enter a new Valut password. This password is used to encrypt/decrypt the file.

Command for viewing secret:
`ansible-vault view secret_vars_common.yml`

Command for editing secret:
`ansible-vault edit secret_vars_common.yml`

# Example `secret_vars_common.yml`:

```
ansible_become_password: 12345678
```

# Example `secret_vars_k3s_nodes.yml`:

```
server: 192.168.1.100
token: 23fasdf3::server:1234asdf
```
