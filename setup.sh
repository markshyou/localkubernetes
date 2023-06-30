#!/bin/bash

# Checking if the user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Updating system packages
sudo apt-get update && sudo apt-get upgrade -y

# Installing required packages
sudo apt-get install -y openssh-server net-tools apt-transport-https curl vim

# Installing Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
sudo docker info | grep -q "Cgroup Driver: systemd"
if [ $? -ne 0 ]; then
    sudo su -
    cat <<EOF > /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdrivers=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl enable docker
fi

# Installing Kubernetes
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl kubernetes-cni
sudo apt-mark hold kubelet kubeadm kubectl kubernetes-cni

# Granting execute permission to the script
chmod +x setup.sh
