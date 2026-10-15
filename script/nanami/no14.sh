#!/bin/bash
GETO_IP="192.224.4.2"          # ISI
YAGA_IP="192.224.4.8"          # ISI
API_DOMAIN="api.jujutsu.K26.com"    # ISI
DB="db_shibuya_K26"

apt update && DEBIAN_FRONTEND=noninteractive apt install -y nginx php-fpm php-mysql
PHPV=$(ls /etc/php | head -1)

mkdir -p /var/www/api
cat > /var/www/api/index.php <<'EOF'
<?php
header('Content-Type: application/json');
$host = gethostname();
$ip = $_SERVER['HTTP_X_REAL_IP'] ?? $_SERVER['REMOTE_ADDR'];
try {
    $pdo = new PDO("mysql:host=__YAGA__;dbname=__DB__", "shibuya", "ShibuyaPass123");
    $st = $pdo->prepare("INSERT INTO request_logs (hostname, client_ip, uri) VALUES (?,?,?)");
    $st->execute([$host, $ip, $_SERVER['REQUEST_URI']]);
    echo json_encode(["server" => $host, "status" => "logged"]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["server" => $host, "error" => $e->getMessage()]);
}
EOF
sed -i "s/__YAGA__/$YAGA_IP/;s/__DB__/$DB/" /var/www/api/index.php

rm -f /etc/nginx/sites-enabled/default
cat > /etc/nginx/sites-available/api <<EOF
server {
    listen 80;
    server_name $API_DOMAIN;
    root /var/www/api;
    index index.php;

    allow $GETO_IP;
    deny all;

    location / { try_files \$uri \$uri/ /index.php?\$query_string; }
    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php$PHPV-fpm.sock;
    }
}
EOF
ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api

service php$PHPV-fpm restart
nginx -t && service nginx restart
