#!/bin/bash
WEB_PROXY_IP="192.224.1.4"     # ISI
WEB_DOMAIN="jujutsu.K26.com"    # ISI

apt update && DEBIAN_FRONTEND=noninteractive apt install -y nginx php-fpm
PHPV=$(ls /etc/php | head -1)

mkdir -p /var/www/web
cat > /var/www/web/index.php <<'EOF'
<?php echo "<h1>Web Frontend</h1><p>Hostname: " . gethostname() . "</p>"; ?>
EOF

rm -f /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/web <<EOF
server {
    listen 80;
    server_name $WEB_DOMAIN;
    root /var/www/web;
    index index.php;

    allow $WEB_PROXY_IP;
    deny all;

    location / { try_files \$uri \$uri/ =404; }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHPV-fpm.sock;
    }
}
EOF
ln -sf /etc/nginx/sites-available/web /etc/nginx/sites-enabled/web

service php$PHPV-fpm restart
nginx -t && service nginx restart
