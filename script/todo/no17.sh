#!/bin/bash
GETO_IP="192.224.4.1"; YAGA_IP="192.224.4.8"     # ISI
DB="db_shibuya_K26"

cat > /var/www/api/index.php <<'EOF'
<?php
header('Content-Type: application/json');
$host   = gethostname();
$remote = $_SERVER['REMOTE_ADDR'];
$ip     = $remote;
// percayai X-Real-IP hanya kalau datang dari geto, dan harus IP valid
if ($remote === '__GETO__' && !empty($_SERVER['HTTP_X_REAL_IP'])
    && filter_var($_SERVER['HTTP_X_REAL_IP'], FILTER_VALIDATE_IP)) {
    $ip = $_SERVER['HTTP_X_REAL_IP'];
}
try {
    $pdo = new PDO("mysql:host=__YAGA__;dbname=__DB__", "shibuya", "ShibuyaPass123");
    $st = $pdo->prepare("INSERT INTO request_logs (hostname, client_ip, uri) VALUES (?,?,?)");
    $st->execute([$host, $ip, $_SERVER['REQUEST_URI']]);
    echo json_encode(["server" => $host, "client_ip" => $ip, "status" => "logged"]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["server" => $host, "error" => $e->getMessage()]);
}
EOF
sed -i "s/__GETO__/$GETO_IP/;s/__YAGA__/$YAGA_IP/;s/__DB__/$DB/" /var/www/api/index.php
php -l /var/www/api/index.php
