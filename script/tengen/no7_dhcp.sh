#!/bin/bash
DOMAIN="K26.com"

# Network 2
MAC_ITADORI="02:42:ba:83:83:00"
MAC_FUSHIGURO="02:42:03:25:97:00"
MAC_ZENIN="02:42:e7:5c:5f:00"
MAC_OKKOTSU="02:42:79:b8:e1:00"

# Network 3
MAC_INO="02:42:30:35:07:00"
MAC_KUSAKABE="02:42:ac:77:cb:00"
MAC_MIWA="02:42:8a:f5:1e:00"
MAC_KUGISAKI="02:42:22:ab:0c:00"

cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time 600;
max-lease-time 7200;
option dhcp-parameter-request-list = concat(option dhcp-parameter-request-list, 77);
authoritative;

option domain-name-servers 192.224.1.2, 192.224.1.3;
option domain-search "$DOMAIN";

# Class Network 2
class "pool1" { match hardware; }
class "pool2" { match hardware; }
subclass "pool1" 1:$MAC_ITADORI;
subclass "pool1" 1:$MAC_FUSHIGURO;
subclass "pool2" 1:$MAC_ZENIN;
subclass "pool2" 1:$MAC_OKKOTSU;

# Class Network 3
class "short" {
    match hardware;
    default-lease-time 1800;
    max-lease-time 1800;
}
class "long" {
    match hardware;
    default-lease-time 43200;
    max-lease-time 43200;
}
subclass "short" 1:$MAC_INO;
subclass "short" 1:$MAC_KUSAKABE;
subclass "long"  1:$MAC_MIWA;

subnet 192.224.4.0 netmask 255.255.255.0 {
}

subnet 192.224.2.0 netmask 255.255.255.0 {
    option routers 192.224.2.1;
    option broadcast-address 192.224.2.255;
    pool {
        range 192.224.2.10 192.224.2.35;
        allow members of "pool1";
    }
    pool {
        range 192.224.2.70 192.224.2.95;
        allow members of "pool2";
    }
}

subnet 192.224.3.0 netmask 255.255.255.0 {
    option routers 192.224.3.1;
    option broadcast-address 192.224.3.255;
    pool {
        range 192.224.3.10 192.224.3.89;
        allow members of "short";
    }
    pool {
        range 192.224.3.100 192.224.3.199;
        allow members of "long";
    }
}

# VIP: kugisaki (alamat tetap, di luar semua pool)
host kugisaki {
    hardware ethernet $MAC_KUGISAKI;
    fixed-address 192.224.3.99;
}
EOF

dhcpd -t -cf /etc/dhcp/dhcpd.conf || { echo "CONFIG ERROR"; exit 1; }
echo "KONFIGURASI VALID"

pkill dhcpd; sleep 2
rm -f /var/run/dhcpd.pid
: > /var/lib/dhcp/dhcpd.leases

dhcpd -4 -cf /etc/dhcp/dhcpd.conf eth0
sleep 1
ps aux | grep [d]hcpd
