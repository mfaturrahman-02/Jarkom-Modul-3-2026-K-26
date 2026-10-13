#!/bin/bash
MAC_KUGISAKI="02:42:22:ab:0c:00"   # GANTI dengan MAC kugisaki

# Hindari blok ganda kalau script dijalankan ulang
sed -i '/^host kugisaki {/,/^}/d' /etc/dhcp/dhcpd.conf

cat >> /etc/dhcp/dhcpd.conf <<EOF

host kugisaki {
    hardware ethernet $MAC_KUGISAKI;
    fixed-address 192.224.3.99;
}
EOF

# validasi, berhenti kalau ada error
dhcpd -t -cf /etc/dhcp/dhcpd.conf || { echo "CONFIG ERROR"; exit 1; }
echo "KONFIGURASI VALID"

# restart dhcpd
pkill dhcpd; sleep 2
rm -f /var/run/dhcpd.pid
dhcpd -4 -cf /etc/dhcp/dhcpd.conf eth0
sleep 1
ps aux | grep [d]hcpd
