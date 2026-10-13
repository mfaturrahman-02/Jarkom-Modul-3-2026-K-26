#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
ip addr add 192.224.4.10/24 dev eth0
ip link set eth0 up
ip route add default via 192.224.4.1
ip route add 192.224.2.0/24 via 192.224.4.1
ip route add 192.224.3.0/24 via 192.224.4.1
