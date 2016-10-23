#!/bin/bash
clear
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
touch minion.sh
tee minion.sh <<-'DONE'
#!/bin/bash
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update -y
sudo apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni
DONE
clear
touch adm
touch min.sh
echo '#!/bin/bash' >> min.sh
kubeadm init >> adm
tail adm -n 1 >> min.sh
echo "Enter the number of minions nodes"
read minionnumb
for ((i=1; i<=$minionnumb; i++))
do
echo "Please give the $i minion ip:"
read minionip
ssh root@$minionip 'bash -s' < minion.sh
ssh root@$minionip 'bash -s' < min.sh
echo "Prerequisites isntalled  $i master."
done
echo "All minions have been configured."
kubectl apply -f https://git.io/weave-kube
for ((i=1; i<100; i++))
do
kubectl get pods --all-namespaces
read -p "Check whether all are in running fully(y/n)"a
if ["$a==y"]
then
kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
kubectl describe svc kubernetes-dashboard -n kube-system
i=100
else ["$a==n"]
echo "Please wait for 100 sec to do the check whether it went to running state."
sleep 100
fi
done
clear
echo
echo
echo
echo "When all the started running then you are good to go"
echo "Kubernetes Setup is done."
echo "Play around with Kubernetes"
sleep 2
