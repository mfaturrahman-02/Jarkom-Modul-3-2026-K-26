#!/bin/bash
GETO_IP="192.224.4.2"; MAKI_IP="192.224.4.3"; PANDA_IP="192.224.4.4"   # ISI
D="jujutsu.K26.com"

cat > /etc/nginx/conf.d/gateway.conf <<EOF
upstream web_cluster {
    server $MAKI_IP:80;
    server $PANDA_IP:80;
}

server {
    listen 80;
    server_name $D www.$D;

    location / {
        proxy_pass http://web_cluster;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
    location /api {
        proxy_pass http://$GETO_IP;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx reload
