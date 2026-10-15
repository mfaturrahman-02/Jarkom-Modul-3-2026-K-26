#!/bin/bash
GOJO_IP="192.224.1.4"; NANAMI_IP="192.224.4.5"; TODO_IP="192.224.4.6"   # ISI

cat > /etc/nginx/conf.d/api_lb.conf <<EOF
upstream api_cluster {
    server $NANAMI_IP:80 weight=3;
    server $TODO_IP:80 weight=1;
}

# percayai header klien HANYA dari gojo
set_real_ip_from $GOJO_IP;
real_ip_header X-Real-IP;

server {
    listen 80;
    location / {
        proxy_pass http://api_cluster;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx reload
