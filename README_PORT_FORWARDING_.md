I had issue with port forwarding 6061 port from my local Server to DigitalOcean cloud server.

Solution: (main issue was with "AllowTcpForwarding" and "GatewayPorts")

## AllowTcpForwarding yes

- What It Does: This parameter controls whether TCP forwarding is permitted on the SSH server. TCP forwarding is the mechanism that allows the SSH server to forward traffic from a port on the server to another destination. This is essential for setting up tunnels, whether for local, remote, or dynamic port forwarding.

## GatewayPorts yes

- What It Does: This parameter controls whether remote forwarded ports (in reverse SSH tunnels) bind to all available interfaces on the SSH server (0.0.0.0), or just to the loopback interface (127.0.0.1).

### 1. **Check Firewall Rules on DigitalOcean**

```bash
sudo ufw status
sudo ufw allow 6061/tcp
```

### 2. **Check SSH Configuration**

- Verify that your SSH configuration on the DigitalOcean server permits port forwarding. Ensure `AllowTcpForwarding` and `GatewayPorts` are set to `yes` in your SSH daemon configuration.

```bash
sudo vi /etc/ssh/sshd_config
```

- Look for these lines (add or modify if necessary):

```
AllowTcpForwarding yes
GatewayPorts yes
```

- After making changes, restart the SSH service:

```bash
sudo systemctl restart sshd
OR
sudo systemctl restart ssh
```

### 3. **Check Local Service Availability**

```bash
curl http://127.0.0.1:6061/
```

### 5. **Ensure Correct Binding on Remote Host**

- The `-R 0.0.0.0:6061:127.0.0.1:6061` parameter in your `autossh` command is correct, as it binds the forwarded port on all interfaces on the remote server. However, ensure that the remote server's security groups or firewall settings (if applicable) allow traffic on that port.
