#!/bin/bash
NANAMI_IP="192.224.4.5"        # ISI
TODO_IP="192.224.4.6"          # ISI

apt update && DEBIAN_FRONTEND=noninteractive apt install -y nginx
rm -f /etc/nginx/sites-enabled/default

cat > /etc/nginx/conf.d/api_lb.conf <<EOF
upstream api_cluster {
    server $NANAMI_IP:80 weight=3;
    server $TODO_IP:80 weight=1;
}

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

nginx -t && service nginx restart
