#!/bin/bash
GETO_IP="192.224.4.2"     # ISI
MAKI_IP="192.224.4.3"     # ISI
PANDA_IP="192.224.4.4"    # ISI
D="jujutsu.K26.com"

apt update && DEBIAN_FRONTEND=noninteractive apt install -y nginx
rm -f /etc/nginx/sites-enabled/default

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
    }
    location /api {
        proxy_pass http://$GETO_IP;
        proxy_set_header Host \$host;
    }
}
EOF

nginx -t && service nginx restart
