#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt install -y isc-dhcp-relay

cat > /etc/default/isc-dhcp-relay <<'EOF'
SERVERS="192.224.4.10"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
EOF
