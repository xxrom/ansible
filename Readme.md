# First start (Ubuntu)

## Install _ansible_

`sudo apt update && 
sudo apt install software-properties-common -y &&
sudo add-apt-repository -y --update ppa:ansible/ansible &&
sudo apt install ansible -y`

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

---

---

---

---

# Harbor (local self-hosted docker registry)

## Harbor how to config and run on master k3s VM (Ubuntu)

1. Dowload latest version from github:
   `wget https://github.com/goharbor/harbor/releases/download/v2.9.3/harbor-offline-installer-v2.9.3.tgz`
2. Extract
   ... todo ...

### Default Harbor user / password:

```
username: admin
password: Harbor12345
```

---

## Harbor example how to publish docker image

1. Run using IP and PORT (192.168.77.150:8044)

2. Creta new user (nikita / password)

3. Login from docker
   `docker login 192.168.77.150:8044`
   `docker login core.harbor.domain --username=admin --password Harbor12345`

4. Create docker image
   `sudo docker build -t library/nginx-example .`

5. Add tag to created image
   `docker tag library/nginx-example 192.168.77.150:8044/library/nginx-example:latest`

6. Push to local docker registry - Harbor
   `docker push 192.168.77.150:8044/library/nginx-example:latest`

7. Use this image name with full path in yaml config file

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

---

---

# Useful links:

-   k8s aliases: https://learnk8s.io/blog/kubectl-productivity
