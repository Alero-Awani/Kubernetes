# ubuntu 1
# here we changed the node ip to the ip of the vm that was assigned by the
# bridge network
NS1='NS1'
NS2='NS2'
NODEIP='172.20.10.10'
BRIDGE_SUBNET='172.16.0.0/24'
BRIDGE_IP='172.16.0.1'
IP1='172.16.0.2'
IP2='172.16.0.3'
TO_NODE_IP='172.20.10.9'
TO_BRIDGE_SUBNET='172.16.1.0/24'
TO_BRIDGE_IP='172.16.1.1'
TO_IP1='172.16.1.2'
TO_IP2='172.16.1.3'

echo "creating the namespace"
sudo ip netns add $NS1
sudo ip netns add $NS2

#to show the newly created namespaces 
ip netns show

sudo ip link add veth10 type veth peer name veth11
sudo ip link add veth20 type veth peer name veth21

ip link show type veth
ip link show veth11
ip link show veth21

echo "adding the veth pairs to the namespaces"
sudo ip link set veth11 netns $NS1
sudo ip link set veth21 netns $NS2

echo "configuring the interface in the network namespaces with ipaddresses/ips for veth11 and veth21"
sudo ip netns exec $NS1 ip addr add $IP1/24 dev veth11
sudo ip netns exec $NS2 ip addr add $IP2/24 dev veth21

echo "Enabling the interfaces inside the network namespace"
sudo ip netns exec $NS1 ip link set dev veth11 up
sudo ip netns exec $NS2 ip link set dev veth21 up

echo "creating the bridge"
sudo ip link add br0 type bridge
ip link show type bridge
ip link show br0
#sudo ip link delete br0/this br0 can be any name you want 

# refer to the diagram for explanation 
echo "Adding the network namespaces interfaces to the bridge"
sudo ip link set dev veth10 master br0
sudo ip link set dev veth20 master br0

echo "Assigning the Ip address to the bridge"
sudo ip addr add $BRIDGE_IP/24 dev br0

echo "Enabling the Bridge"
sudo ip link set dev br0 up

echo "Enabling the Interfaces connected to the bridge"
sudo ip link set dev veth10 up
sudo ip link set dev veth20 up

echo "setting the loopback interfaces in the network namespaces" #so it can ping itself
sudo ip netns exec $NS1 ip link set lo up
sudo ip netns exec $NS2 ip link set lo up 

# view the added ip addresses 
sudo ip netns exec $NS1 ip a 
sudo ip netns exec $NS2 ip a 

echo "setting the default route in the network namespaces"
# we want to set up traffic going from the namespaces to the outside world via the bridge 
# this will enable the namespaces to communicate with each other and it is done with setting up 
# a route 
sudo ip netns exec $NS1 ip route add default via $BRIDGE_IP dev veth11
sudo ip netns exec $NS2 ip route add default via $BRIDGE_IP dev veth21

echo "setting the route on the node to reach the network namespaces on the other vm"
#we are using eth1 because that is actually the bridge adapter
sudo ip route add $TO_BRIDGE_SUBNET via $TO_NODE_IP dev eth1

echo "Enable ip forwarding  on the node "
sudo sysctl -w net.ipv4.ip_forward=1

#ping adaptor attached to ns1
sudo ip netns exec $NS1 ping -W 1 -c 2 172.16.0.2

#ping the bridge
sudo ip netns exec $NS1 ping -W 1 -c 2 172.16.0.1

#ping the adapter of the second container 
sudo ip netns exec $NS1 ping -W 1 -c 2 172.16.0.3

#ping the other server(ubuntu2)
#this is the ip of the the second vm
sudo ip netns exec $NS1 ping -W 1 -c 2 172.20.10.9

#ping the bridge of the ubuntu2 server 
sudo ip netns exec $NS1 ping -W 1 -c 5 172.16.1.1

#ping the first container on ubuntu2
sudo ip netns exec $NS1 ping -W 1 -c 2 172.16.1.2

#ping the second container on ubuntu2 
sudo ip netns exec $NS1 ping -W 1 -c 5 172.16.1.3


