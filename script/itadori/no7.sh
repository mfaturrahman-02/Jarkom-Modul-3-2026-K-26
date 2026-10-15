#!/bin/sh
echo "===== $(hostname) ====="
echo "--- MAC ---"
cat /sys/class/net/eth0/address
echo "--- IP, mask, broadcast ---"
ip -4 addr show eth0 | grep inet
echo "--- Routing ---"
ip route
echo "--- DNS dan domain-search ---"
cat /etc/resolv.conf
echo "--- Ping gateway ---"
GW=$(ip route | awk '/default/{print $3}')
ping -c 2 "$GW"
