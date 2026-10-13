#!/bin/bash
# ISI MAC ASLI (hasil: cat /sys/class/net/eth0/address)
MAC_ITADORI="02:42:ba:83:83:00"
MAC_FUSHIGURO="02:42:03:25:97:00"
MAC_ZENIN="02:42:e7:5c:5f:00"
MAC_OKKOTSU="02:42:79:b8:e1:00"

cat > /etc/dhcp/dhcpd.conf <<EOF
default-lease-time 600;
max-lease-time 7200;
authoritative;

class "pool1" { match hardware; }
class "pool2" { match hardware; }

subclass "pool1" 1:$MAC_ITADORI;
subclass "pool1" 1:$MAC_FUSHIGURO;
subclass "pool2" 1:$MAC_ZENIN;
subclass "pool2" 1:$MAC_OKKOTSU;

subnet 192.224.4.0 netmask 255.255.255.0 {
}

subnet 192.224.2.0 netmask 255.255.255.0 {
    option routers 192.224.2.1;

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
    range 192.224.3.10 192.224.3.89;
    option routers 192.224.3.1;
}
EOF

# validasi, berhenti kalau ada error
dhcpd -t -cf /etc/dhcp/dhcpd.conf || { echo "CONFIG ERROR"; exit 1; }

# hentikan dhcpd lama dan hapus lease lama
pkill dhcpd; sleep 2
rm -f /var/run/dhcpd.pid
: > /var/lib/dhcp/dhcpd.leases

# jalankan lagi
dhcpd -4 -cf /etc/dhcp/dhcpd.conf eth0
sleep 1
ps aux | grep [d]hcpd
