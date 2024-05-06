"PV" - persistent volume - folder on some part of the disk where all data will be stored (for example 10Gi).
"PVC" - persistent volume claim - some part of PV we want to use in PV folder, so it should be <= PV side (for example 9Gi).

Set up NFS on the same server where your master node is located. This setup is often used in smaller or test environments where simplicity and cost efficiency are priorities. Here’s how you can configure NFS on the same server and use it for Kubernetes persistent storage, especially suitable for scenarios like a k3s cluster in a Proxmox environment.

### Step-by-Step Guide to Setting Up NFS on Your Master Node Server

#### 1. Install NFS Server

Start by installing the NFS server on your master node. This process will vary depending on your operating system, but here’s how you can do it on an Ubuntu-based system:

```bash
sudo apt update
sudo apt install nfs-kernel-server
```

#### 2. Configure NFS Exports

Create a directory that will be shared over NFS and configure the exports.

```bash
sudo mkdir -p /srv/nfs/kubedata  # Create a directory for NFS exports
sudo chown nobody:nogroup /srv/nfs/kubedata
sudo chmod 777 /srv/nfs
sudo chmod 777 /srv/nfs/kubedata
```

Edit the `/etc/exports` file to add this directory:

```bash
sudo nano /etc/exports
```

Add the following line to allow access from your local network (adjust the IP range according to your network):

```plaintext
/srv/nfs/kubedata *(rw,sync,no_subtree_check,no_root_squash)
```

After saving the file, export the shared directory:

```bash
sudo exportfs -ra
```

#### 3. Start and Enable NFS Server

Ensure the NFS server is running and will start on boot:

```bash
sudo systemctl start nfs-kernel-server
sudo systemctl enable nfs-kernel-server
```

#### 4. Configure Kubernetes to Use NFS

Now, you’ll need to configure Kubernetes to use this NFS server as a storage solution. You can create a Persistent Volume (PV) that references the NFS server and a Persistent Volume Claim (PVC) that Kubernetes workloads can use to store data.

Create a file called `nfs-pv.yaml` with the following content (WITHOUT namespace , because it's global for cluster !!!!!!!):

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: nfs
  nfs:
    path: /srv/nfs/kubedata
    server: 192.168.77.150 # Master IP address if you have only one master , it two then ... =)
```

Create a file called `nfs-pvc.yaml` (including namespace if no default !!!!):

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs-pvc
  namespace: user-tracker # !!!!!!!!!!!!!!!!!!!!! IMPORTANT TO BE AWARE OF THAT !!!!!!!!!!!!
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: nfs
  resources:
    requests:
      storage: 10Gi
```

Apply these configurations:

```bash
kubectl apply -f nfs-pv.yaml
kubectl apply -f nfs-pvc.yaml
```

#### 5. Verify Configuration

Check that the PV and PVC are properly set up and that the PVC is bound to the PV:

```bash
kubectl get pv
kubectl get pvc
```

For deleting pv/pvc:

```bash
kubectl delete pv nfs-pv
kubectl delete pvc nfs-pvc
```

#### 6. Use the PVC in Your Deployments

Now you can reference `nfs-pvc` in your Kubernetes deployments to ensure that your applications can persist data across pod recreations and restarts.

### Benefits and Considerations

- **Simplicity:** Having NFS on the same server simplifies the architecture.
- **Cost Efficiency:** Reduces the need for additional hardware or virtual machines.
- **Performance:** Local NFS may offer better performance compared to network-attached storage, especially in terms of latency.

However, this setup may also have drawbacks like increased load on the master node and potential risks if the master node has issues, it could impact both your Kubernetes control plane and your persistent storage. This setup is recommended for testing, development, or small production environments with appropriate backups and monitoring.
