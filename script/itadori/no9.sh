  GNU nano 8.7                         no9.sh
#!/bin/sh
echo "===== $(hostname) - $(date) ====="
pkill udhcpc 2>/dev/null
ip addr flush dev eth0
ip link set eth0 up
echo "--- minta lease ---"
udhcpc -i eth0 -n -t 3 -T 2
echo "--- IP ---"
ip -br addr show eth0
echo "--- Route ---"
ip route
echo "--- Ping gateway ---"
GW=$(ip route | awk '/default/{print $3}')
if [ -n "$GW" ]; then ping -c 2 "$GW"; else echo "TIDAK ADA default route"; fi
