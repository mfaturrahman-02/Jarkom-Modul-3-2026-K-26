#!/bin/bash
rm -f /root/dhcp.pcap
echo "Capture dimulai (maks 60 detik). Sekarang jalankan udhcpc di client."
timeout 60 tcpdump -ni eth0 -w /root/dhcp.pcap port 67 or port 68 2>/dev/null
echo "Capture selesai: /root/dhcp.pcap"
