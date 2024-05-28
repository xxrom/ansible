### Step-by-Step Setup for Hosting Multiple Domains

#### Step 1: DNS Configuration

For each domain that you want to host on your server:

1. **Set up DNS records**: Log into your GoDaddy DNS management console (or wherever your domain’s DNS is managed) and point each domain to the public IP address of your server. This typically involves setting `A` records for the root domain (`example.com`) and any subdomains like `www`.

#### Step 2: Server Configuration (Using Nginx)

Assuming you have Nginx installed on your DigitalOcean server, you’ll configure each site like this:

1. **Create a Configuration File for Each Domain**: For each domain, create a separate configuration file under `/etc/nginx/sites-available/`. This keeps your configurations organized and easy to manage.

   ```bash
   sudo nano /etc/nginx/sites-available/domain1.com
   ```

   And add the following configuration:

   ```nginx
   server {
       listen 80;
       server_name domain1.com www.domain1.com;

       root /var/www/domain1.com/html;
       index index.html index.htm index.nginx-debian.html;

       location / {
           try_files $uri $uri/ =404;
       }
   }
   ```

   Repeat this for another domain, `domain2.com`, adjusting the `server_name` and `root` directives accordingly.

2. **Enable the Sites**:
   Create symbolic links for each configuration from `sites-available` to `sites-enabled` to activate them:

   ```bash
   sudo ln -s /etc/nginx/sites-available/ttt.app /etc/nginx/sites-enabled/ttt.app
   ```

3. **Test and Reload Nginx**:
   Always check your configuration for syntax errors before reloading Nginx:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

#### Step 3: Web Content

1. **Place your content** in the respective directories specified in each Nginx configuration under the `root` directive. For example, HTML files for `domain1.com` should go into `/var/www/domain1.com/html`.

#### Step 4: Secure with HTTPS (Optional but Recommended)

For better security, consider securing your domains with SSL/TLS certificates:

1. **Install Certbot**:
   ```bash
   sudo apt install certbot python3-certbot-nginx
   ```
2. **Get SSL/TLS Certificates**:
   Run Certbot for each domain to obtain a certificate and automatically adjust the Nginx configurations to use HTTPS:
   ```bash
   sudo certbot --nginx -d domain1.com -d www.domain1.com
   sudo certbot --nginx -d domain2.com -d www.domain2.com
   ```

### Conclusion

By following these steps, you can host multiple websites on a single server, each accessible via its own domain name. Nginx handles the incoming requests and serves content based on the requested domain. This setup is efficient and scalable, suitable for hosting several small to medium websites.
