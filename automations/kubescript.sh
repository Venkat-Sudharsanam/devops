#!/bin/bash
echo "This is Kubernetes 1.4 setup of master and minion."
echo
echo
echo "Run this script on the kubernetes master node."
echo
echo
echo "Make sure that the ssh key has been created from master node to all minion."
echo
echo
echo "Prerequsites is you need "Ubuntu 16.04" OS"
echo
echo
sleep 5
clear
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y
apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni
clear
echo "Master setup has been finished."
echo "Setting up minions"
mkdir -p /kubernetes
cd /kubernetes
echo "Please provide a name for the script to run in your minions"
read $minion
touch $minion
tee $minion <<-'DONE'
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update -y
apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni
DONE
clear
echo "Enter the number of minions nodes"
read $minionnumb
for ((i=1; i<=$minionnumb; i++))
do
echo "Please give the $i minion ip:"
read minionip
ssh root@$minionip /script/$name.sh
echo "Prerequisites isntalled  $i master."
done
echo "All minions have been configured."
sleep 2
clear
kubeadm init