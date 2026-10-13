echo "nameserver 192.168.122.1" > /etc/resolv.conf
ip addr add 192.224.4.2/24 dev eth0
ip link set eth0 up
ip route add default via 192.224.4.1
