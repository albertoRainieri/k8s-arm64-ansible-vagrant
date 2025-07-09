#!/bin/bash

# Kubernetes ARM64 Cluster Setup Script with Ansible
# This script helps you set up a Kubernetes cluster on ARM64 using Ansible

set -e

echo "=========================================="
echo "Kubernetes ARM64 Cluster Setup with Ansible"
echo "=========================================="

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    echo "Error: Vagrant is not installed. Please install Vagrant first."
    exit 1
fi

# Check if Ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Error: Ansible is not installed. Please install Ansible first."
    echo "Install with: pip install ansible"
    exit 1
fi

# Check if VirtualBox or libvirt is available
if command -v VBoxManage &> /dev/null; then
    PROVIDER="virtualbox"
    echo "Using VirtualBox as provider"
elif command -v virsh &> /dev/null; then
    PROVIDER="libvirt"
    echo "Using libvirt as provider"
else
    echo "Error: Neither VirtualBox nor libvirt is available."
    echo "Please install one of them to proceed."
    exit 1
fi

echo ""
echo "Starting Kubernetes cluster..."
echo "This will take several minutes..."

# Start the VMs
vagrant up

echo ""
echo "Waiting for VMs to be ready..."
sleep 30

echo ""
echo "Running Ansible playbooks..."

# Test connectivity
echo "Testing connectivity to nodes..."
ansible all -m ping

# Install and configure Kubernetes
echo "Installing and configuring Kubernetes..."
ansible-playbook playbook/install-k8s.yaml

# Initialize cluster on master
echo "Initializing cluster on master node..."
ansible-playbook playbook/initialize-cluster.yaml

# Join worker nodes
echo "Joining worker nodes to cluster..."
ansible-playbook playbook/join-cluster.yaml

# Verify cluster
echo "Verifying cluster status..."
ansible-playbook playbook/verify-cluster.yaml

echo ""
echo "=========================================="
echo "Cluster setup completed!"
echo "=========================================="
echo ""
echo "To access the cluster:"
echo "1. Connect to master node: vagrant ssh kmaster"
echo "2. Check cluster status: kubectl get nodes"
echo "3. Check all pods: kubectl get pods --all-namespaces"
echo ""
echo "To access from your host machine:"
echo "1. Copy kubeconfig: scp vagrant@192.168.59.100:/home/vagrant/.kube/config ~/.kube/config-arm64"
echo "2. Set context: export KUBECONFIG=~/.kube/config-arm64"
echo "3. Test: kubectl get nodes"
echo ""
echo "Cluster details:"
echo "- Master: 192.168.59.100"
echo "- Worker1: 192.168.59.101"
echo "- Worker2: 192.168.59.102"
echo "- Root password: kubeadmin"
echo ""
echo "Useful commands:"
echo "- vagrant ssh kmaster    # Connect to master"
echo "- vagrant ssh kworker1   # Connect to worker1"
echo "- vagrant ssh kworker2   # Connect to worker2"
echo "- vagrant destroy -f     # Destroy all VMs"
echo "- ansible-playbook playbook/verify-cluster.yaml  # Verify cluster"
echo "" 