#!/bin/bash
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt update && apt install -y isc-dhcp-server

# Interface yang melayani DHCP
sed -i 's/^INTERFACESv4=.*/INTERFACESv4="eth0"/' /etc/default/isc-dhcp-server

cat > /etc/dhcp/dhcpd.conf <<'EOF'
default-lease-time 600;
max-lease-time 7200;
authoritative;

# Network 4: subnet lokal
subnet 192.224.4.0 netmask 255.255.255.0 {
}

# Network 2
subnet 192.224.2.0 netmask 255.255.255.0 {
    option routers 192.224.2.1;
    option broadcast-address 192.224.2.255;
}

# Network 3
subnet 192.224.3.0 netmask 255.255.255.0 {
    option routers 192.224.3.1;
    option broadcast-address 192.224.3.255;
}
EOF
