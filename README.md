# 🚀 ARM64 Kubernetes Cluster with Ansible & Vagrant

A complete infrastructure-as-code solution for deploying multi-node Kubernetes clusters on ARM64 architecture using Ansible automation and Vagrant virtualization.

## ✨ Features

- **Multi-node Kubernetes cluster** (1 master + 2 workers)
- **ARM64 architecture support** for Apple Silicon and ARM servers
- **Fully automated deployment** with Ansible playbooks
- **Vagrant-based development environment** for easy testing
- **Production-ready configuration** with proper networking and security
- **Calico CNI** for advanced network policies
- **Helm package manager** pre-installed
- **Bash completion** and kubectl aliases for enhanced productivity

## 🏗️ Architecture

- **Master Node**: `kmaster` (192.168.59.100) - 2GB RAM, 2 CPUs
- **Worker Node 1**: `kworker1` (192.168.59.101) - 2GB RAM, 2 CPUs  
- **Worker Node 2**: `kworker2` (192.168.59.102) - 2GB RAM, 2 CPUs

## 📋 Prerequisites

- **Vagrant** installed on your system
- **Ansible** installed (`pip install ansible`)
- **VirtualBox** or **libvirt (KVM)** as virtualization provider
- **At least 6GB RAM** and **4 CPU cores** available
- **Ubuntu 24.04 ARM64** Vagrant box

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/albertoRainieri/k8s-arm64-ansible-vagrant.git
cd k8s-arm64-ansible-vagrant
```

### 2. Automated Setup (Recommended)
```bash
# Make the script executable
chmod +x setup.sh

# Run the complete setup
./setup.sh
```

This script will:
- ✅ Check prerequisites
- ✅ Start Vagrant VMs
- ✅ Run all Ansible playbooks in sequence
- ✅ Verify the cluster

### 3. Manual Setup
```bash
# Start all VMs
vagrant up

# Wait for VMs to be ready
sleep 30

# Test connectivity
ansible all -m ping

# Install and configure Kubernetes
ansible-playbook playbook/install-k8s.yaml

# Initialize cluster on master
ansible-playbook playbook/initialize-cluster.yaml

# Join worker nodes
ansible-playbook playbook/join-cluster.yaml

# Verify cluster
ansible-playbook playbook/verify-cluster.yaml
```

## 📁 Project Structure

```
k8s-arm64-ansible-vagrant/
├── Vagrantfile              # VM definitions
├── ansible.cfg              # Ansible configuration
├── hosts.yaml               # Ansible inventory
├── create-k8s-cluster.yaml  # Main orchestration playbook
├── setup.sh                 # Automated setup script
├── playbook/
│   ├── vars.yaml            # Variables for all playbooks
│   ├── install-k8s.yaml     # Install Kubernetes on all nodes
│   ├── initialize-cluster.yaml # Initialize cluster on master
│   ├── join-cluster.yaml    # Join worker nodes
│   └── verify-cluster.yaml  # Verify cluster status
└── README.md                # This file
```

## 🔧 Ansible Playbooks

### `install-k8s.yaml`
- Disables swap and firewall
- Loads required kernel modules (overlay, br_netfilter)
- Installs containerd and Docker
- Installs Kubernetes components (kubelet, kubeadm, kubectl)
- Configures system settings and SSH

### `initialize-cluster.yaml`
- Pulls Kubernetes container images
- Initializes the cluster with kubeadm
- Deploys Calico network plugin
- Generates join command for workers
- Installs Helm
- Sets up kubectl configuration

### `join-cluster.yaml`
- Sets hostname based on inventory
- Copies join command from master
- Joins worker nodes to cluster
- Waits for nodes to be ready

### `verify-cluster.yaml`
- Checks cluster information
- Lists all nodes and their status
- Shows system pods status
- Verifies kubelet service

## 🌐 Network Configuration

- **Pod Network CIDR**: 192.168.60.0/24
- **Service Network**: 10.96.0.0/12 (default)
- **Network Plugin**: Calico
- **Private Network**: 192.168.59.0/24 for node communication

## 📦 Components Installed

- **Container Runtime**: containerd
- **Container Engine**: Docker CE
- **Network Plugin**: Calico
- **Package Manager**: Helm 3
- **Additional Tools**: git, nfs-common, bash-completion

## 🔍 Verify the Cluster

### From Master Node
```bash
# Connect to the master node
vagrant ssh kmaster

# Check cluster status
kubectl get nodes
kubectl get pods --all-namespaces
```

### From Host Machine
```bash
# Copy kubeconfig from master to your local machine
scp vagrant@192.168.59.100:/home/vagrant/.kube/config ~/.kube/config-arm64

# Set the context
export KUBECONFIG=~/.kube/config-arm64

# Test access
kubectl get nodes
```

## 🛠️ Useful Commands

```bash
# VM Management
vagrant ssh kmaster      # Connect to master
vagrant ssh kworker1     # Connect to worker1
vagrant ssh kworker2     # Connect to worker2
vagrant destroy -f       # Destroy all VMs
vagrant reload           # Reload VMs

# Cluster Management
ansible-playbook playbook/verify-cluster.yaml  # Verify cluster
kubectl get nodes        # List nodes
kubectl get pods -A      # List all pods
kubectl cluster-info     # Cluster information
```

## 🎯 Use Cases

- Development and testing environments
- Learning Kubernetes on ARM64
- CI/CD pipeline testing
- Local development clusters
- ARM64 infrastructure validation