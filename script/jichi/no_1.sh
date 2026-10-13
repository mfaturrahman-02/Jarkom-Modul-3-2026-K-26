#!/bin/bash
# Nameserver awal supaya bisa unduh paket
echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Pastikan tool tersedia
apt update && apt install -y iptables iproute2 iputils-ping isc-dhcp-client

# eth0: WAN dari NAT (DHCP)
ip link set eth0 up
dhclient eth0

# eth1-eth4: gateway tiap network
ip addr add 192.224.1.1/24 dev eth1 && ip link set eth1 up
ip addr add 192.224.2.1/24 dev eth2 && ip link set eth2 up
ip addr add 192.224.3.1/24 dev eth3 && ip link set eth3 up
ip addr add 192.224.4.1/24 dev eth4 && ip link set eth4 up

# IPv4 forwarding
sysctl -w net.ipv4.ip_forward=1

# Source NAT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
