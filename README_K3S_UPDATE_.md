# Master:

`curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.30.0+k3s1" INSTALL_K3S_EXEC="server" sh -`

# Agent:

`curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.30.0+k3s1" INSTALL_K3S_EXEC="agent" K3S_URL="https://192.168.77.150:6443" K3S_TOKEN="..." sh -`
