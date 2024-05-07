# Harbor (local self-hosted docker registry)

## Harbor how to config and run on master k3s VM (Ubuntu)

1. Download latest version from github:
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

2. Create new user (nikita / password)

- add IP to insecure registries list in docker app:
- - "insecure-registries": ["192.168.77.150:8044"]

3. Login from docker
   `docker login 192.168.77.150:8044`
   `docker login core.harbor.domain --username=admin --password Harbor12345`

4. Create simple nginx local 'Dockerfile'

```
FROM nginx:1.10.1-alpine
COPY index.html /usr/share/nginx/html
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

```

5. Create docker image
   `sudo docker build -t nginx-example .`

6. Add tag to created image
   `docker tag nginx-example 192.168.77.150:8044/library/nginx-example:latest`

7. Push to local docker registry - Harbor
   `docker push 192.168.77.150:8044/library/nginx-example:latest`

8. Use this image name with full path in yaml config file
