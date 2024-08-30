## How to add subdomain to current domain that will point to "VM_IP":

- "dev.litl.cloud"
- Type: "A",
- Name: "dev" (it will be "dev.litl.cloud"),
- Value: "VM_IP",
- TTL: "1/2h"

## Setup simple nginx to validate it:

- `sudo nano /etc/nginx/sites-available/default`

```
server {
    listen 80;
    server_name dev.litl.cloud;

    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}
```

- Check nginx config for errors `sudo nginx -t`

- simple index.html for testing:
  `echo "<h1>Welcome to dev.litl.cloud</h1>" | sudo tee /var/www/html/index.html`
  -- `sudo echo "Test text" > /var/www/html/index.html` could face issues with creating file permission (that's why we are using `sudo tee`)

- `sudo systemctl restart nginx`
- Test "dev.litl.cloud" (`curl localhost:80`)
