#!/bin/bash
GOJO_IP="192.224.1.4"; NANAMI_IP="192.224.4.5"; TODO_IP="192.224.4.6"; KIRARA_IP="192.224.4.7"   # ISI

cat > /etc/nginx/conf.d/api_lb.conf <<EOF
upstream api_cluster {
    server $NANAMI_IP:80 weight=3 max_fails=2 fail_timeout=5s;
    server $TODO_IP:80   weight=1 max_fails=2 fail_timeout=5s;
    server $KIRARA_IP:80 backup;
}

set_real_ip_from $GOJO_IP;
real_ip_header X-Real-IP;

server {
    listen 80;
    location / {
        proxy_pass http://api_cluster;
        proxy_connect_timeout 2s;
        proxy_next_upstream error timeout http_502 http_503 http_504;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx reload
