To add logging to your `ssh-tunnel.service` systemd service for better monitoring and troubleshooting, you'll need to adjust the `ExecStart` line to include verbosity options and redirect the output to a log file. Here’s how you can configure this:

### Step 1: Create a Log File

First, decide where you want your log files to be stored. A common location for custom logs on Linux systems is within the `/var/log/` directory. You'll need to create a log file that your service will write to.

1. **Create Log File**:

   ```bash
   sudo touch /var/log/ssh-tunnel.log
   ```

2. **Set Permissions**:
   Ensure that the file is writable by the user under which the SSH tunnel runs, assuming your service runs under `adunda`:
   ```bash
   sudo chown adunda:adunda /var/log/ssh-tunnel.log
   ```

### Step 2: Modify the systemd Service File

Edit your systemd service file to direct the output of `autossh` to the log file.

1. **Edit Service File**:

   ```bash
   sudo nano /etc/systemd/system/ssh-tunnel.service
   ```

2. **Update `ExecStart`**:
   Modify the `ExecStart` line to include verbosity and log output. Adding `-v` increases verbosity (you can use `-vv` or `-vvv` for more detailed logs). Redirect both standard output and standard error to your log file:

   ```ini
   [Service]
   ExecStart=/usr/bin/autossh -M 0 -v -N -R 127.0.0.1:6070:localhost:80 -o "ServerAliveInterval=30" -o "ServerAliveCountMax=100" -o "ExitOnForwardFailure=yes" -i /home/adunda/.ssh/id_do tt@178.128.195.181 >> /var/log/ssh-tunnel.log 2>&1
   Restart=always
   RestartSec=30
   ```

   Here:

   - **`>> /var/log/ssh-tunnel.log 2>&1`** redirects both standard output (`stdout`) and standard error (`stderr`) to the log file. This ensures all output, including errors, is logged.

### Step 3: Reload and Restart the systemd Service

After updating the service configuration, reload the systemd manager configuration and restart your service to apply the changes:

1. **Reload Systemd**:

   ```bash
   sudo systemctl daemon-reload
   ```

2. **Restart Service**:

   ```bash
   sudo systemctl restart ssh-tunnel.service
   ```

3. **Check Status**:
   To ensure the service is running without immediate errors:
   ```bash
   sudo systemctl status ssh-tunnel.service
   ```

### Step 4: Monitoring Logs

Now that your service is set up to log its output, you can monitor these logs with commands like `tail` or use them in troubleshooting:

- **View Logs**:

  ```bash
  tail -f /var/log/ssh-tunnel.log
  ```

- **Check for Recent Entries**:
  ```bash
  grep "error" /var/log/ssh-tunnel.log
  ```

This setup will help you capture and review the operational logs of your SSH tunnel, providing insights into any failures or issues that might occur.
