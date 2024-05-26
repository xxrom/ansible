# First start (Ubuntu)

## Install _ansible_

`sudo apt update && 
sudo apt install software-properties-common -y &&
sudo add-apt-repository -y --update ppa:ansible/ansible &&
sudo apt install ansible -y`

---

## Ansible host file location

- linux `/usr/local/etc/ansible/`
- macos `/etc/ansible/hosts`

---

## Add vault password file

Run commands from the ansible root folder:

`echo "myVaultPassword" > ./vaultpassw
chmod 600 ./valutpassw`

Be sure that vaultpassw file is in .gitignore file

## How to use vault password file

`ansible-playbook --vault-password-file ./vaultpassw playbook.yml`

---

## How to use ansible _with_ vault values:

`asnbile-playbook install_common.yml --ask-vault-pass`

## How to use ansible with inventory (to set reset some parameters if needed)

`ansible-playbook -i production.yml --vault-password-file ./vaultpassw ./harbor_registry.yml`

# How to use ansible _without_ vault values:

`asnbile-playbook install_common.yml`

# How to ping interface nodes for issues validation

`ansible -i ./production.yml latte -m ping -vvv`
`ansible -i ./dev.yml alice -m ping -vvv`
`ansible -i ./dev_master.yml adunda -m ping -vvv`

# Add ansible secret vault for using _password_ and other _sencetive_ values:

Command for creating secret file for storing values:
`ansible-vault create secret_vars_common.yml`

- then enter a new Valut password. This password is used to encrypt/decrypt the file.

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

# Use ssh with private key connection to VMs, so it will be easier and secure

1. `ssh-keygen -t rsa -b 4096`
   Set a file location and press ‘Enter’ double tiems for the passphrase (use empty password). 🔑

2. Transfer the public key `ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote_address`

3. Test: `ssh -i ~/.ssh/id_rsa username@remote_address`

```
all:
  children:
    renaissance:
      hosts:
        latte:
          ansible_host: 192.168.77.170
          ansible_user: latte
          ansible_ssh_private_key_file: /Users/nikita/ansible/ssh/latte

```

---

---

---

---

---

```
...
containers:
- name: nginx
  image: 192.168.77.150:8044/library/nginx-example
  imagePullPolicy: IfNotPresent
  ports:
  - containerPort: 80
...

```

8. On Master and Nodes add this mirror for checking docker images:
   file: `/etc/rancher/k3s/registries.yaml`
   use IP and PORT of the Harbor VMs:

```
mirrors:
  "192.168.77.150:8044":
    endpoint:
      - "http://192.168.77.150:8044"
```

9. Restart k3s
   `sudo systemctl restart k3s`

---

---

# Common commands:

- reboot all:
  `ansible-playbook -i dev_nodes.yml --vault-password-file ./vaultpassw ./reboot.yml`

- label unlabeled worker from the master node:
  `kubectl label node alice node-role.kubernetes.io/worker=worker`

- check env values on worker nodes:
  `sudo cat /etc/systemd/system/k3s-agent.service.env`

- restart k3s-agent on worker nodes:
  `sudo systemctl restart k3s-agent`

---

---

# Useful links:

- k8s aliases: https://learnk8s.io/blog/kubectl-productivity

---
