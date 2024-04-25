Fail2Ban is a tool that helps protect your server against brute-force attacks by dynamically altering your firewall rules to ban IPs that show malicious behavior as defined by "fail" patterns, typically found in server log files. To properly set up and configure Fail2Ban on an Ubuntu server, follow these steps:

### Step 1: Install Fail2Ban

1. Update your package lists:

    ```bash
    sudo apt update
    ```

2. Install Fail2Ban:
    ```bash
    sudo apt install fail2ban
    ```

### Step 2: Configure Fail2Ban

Fail2Ban works with "jail" files, which define parameters for monitoring log files and banning IPs under certain conditions.

1. **Create a Copy of the Jail Configuration File**: It’s good practice to work with a local configuration file that overrides the default configuration to avoid losing custom settings during updates.

    ```bash
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    ```

2. **Edit the Jail Configuration**:

    - Open the newly copied configuration file:

        ```bash
        sudo nano /etc/fail2ban/jail.local
        ```

    - Configure the default settings as needed. For example, set the default ban time and find time:

        ```ini
        [DEFAULT]
        bantime = 10m  # Duration to ban IPs. This can be '10m', '1h', '1d' for minutes, hours, or days respectively.
        findtime = 10m  # The time frame during which a host must make the number of failed attempts defined in `maxretry` to get banned.
        maxretry = 5   # Number of failures before an IP is banned.
        ignoreip = 127.0.0.1/8 ::1  # List of IPs to ignore from banning
        ```

    - Enable and configure specific jails according to the services you’re running. For instance, for SSH:
        ```ini
        [sshd]
        enabled = true
        port = ssh
        filter = sshd
        logpath = /var/log/auth.log
        maxretry = 5
        ```

3. **Create or Modify Filters** (if necessary):
    - Filters define how Fail2Ban identifies failed login attempts from the log files. Fail2Ban comes with many pre-configured filters, but you can customize or create new ones as needed.
    - Check the existing filters at `/etc/fail2ban/filter.d/` and customize if required.

### Step 3: Control the Fail2Ban Service

1. **Start the Fail2Ban service**:

    ```bash
    sudo systemctl start fail2ban
    ```

2. **Enable Fail2Ban to start at boot**:

    ```bash
    sudo systemctl enable fail2ban
    ```

3. **Check the status of Fail2Ban**:
    ```bash
    sudo systemctl status fail2ban
    ```

### Step 4: Monitoring and Testing

1. **View Fail2Ban Logs** to see which IPs have been banned:

    ```bash
    sudo zgrep 'Ban' /var/log/fail2ban.log
    ```

2. **Test Fail2Ban Configuration**:

    - You can simulate failed login attempts (from a non-critical IP) to ensure that Fail2Ban is correctly identifying and banning the attempts.

3. **Unban an IP Address** if you need to remove a ban manually:
    ```bash
    sudo fail2ban-client set sshd unbanip 192.168.1.100
    ```

### Step 5: Update Regularly

-   Regularly update your Fail2Ban rules and software to protect against new attack vectors:
    ```bash
    sudo apt update && sudo apt upgrade
    ```

By following these steps, you'll have Fail2Ban properly set up and configured to help secure your server by monitoring and blocking suspicious activities based on the defined criteria in your jail configurations.
