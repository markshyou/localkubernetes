#!/bin/bash

# Checking if the user is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Getting the master node IP address
read -p "Enter the master node IP address: " master_ip

# Initializing Kubernetes master
kubeadm_output=$(sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=$master_ip)

# Creating kubeconfig directory and copying admin.conf
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Verifying the cluster status
kubectl get pods --all-namespaces
kubectl get nodes

# Extracting kubeadm join information
join_command=$(echo "$kubeadm_output" | grep "kubeadm join")

# Printing kubeadm join information
echo "Kubeadm join information:"
echo "$join_command"

# Creating worker.sh file with kubeadm join information
cat <<EOF > worker.sh
#!/bin/bash

# Running kubeadm join command
$join_command
EOF

# Granting execute permission to the worker.sh file
chmod +x worker.sh

# Deploying Flannel network
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Granting execute permission to the script
chmod +x master.sh
