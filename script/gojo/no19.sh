#!/bin/bash
GETO_IP="192.224.4.2"; MAKI_IP="192.224.4.3"; PANDA_IP="192.224.4.4"   # ISI
D="jujutsu.K26.com"

cat > /etc/nginx/conf.d/gateway.conf <<EOF
upstream web_cluster {
    server $MAKI_IP:80;
    server $PANDA_IP:80;
}

proxy_cache_path /var/cache/nginx/web levels=1:2 keys_zone=web_cache:10m max_size=100m inactive=10m;
limit_req_zone \$binary_remote_addr zone=api_limit:10m rate=10r/s;

log_format audit '\$remote_addr "\$request" \$status ups=\$upstream_status cache=\$upstream_cache_status rl=\$limit_req_status rt=\$request_time';

server {
    listen 80;
    server_name $D www.$D;
    access_log /var/log/nginx/gojo_audit.log audit;

    location / {
        proxy_pass http://web_cluster;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;

        proxy_cache web_cache;
        proxy_cache_valid 200 10m;
        add_header X-Cache-Status \$upstream_cache_status always;
    }

    location /api {
        limit_req zone=api_limit;
        proxy_pass http://$GETO_IP;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

nginx -t && service nginx restart
