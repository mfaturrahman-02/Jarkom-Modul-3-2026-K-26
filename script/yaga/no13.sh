#!/bin/bash
DB="db_shibuya_K26"

apt update && DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server

mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql
cat > /etc/mysql/mariadb.conf.d/99-replication.cnf <<EOF
[mysqld]
bind-address = 0.0.0.0
server-id    = 1
log_bin      = /var/log/mysql/mysql-bin.log
EOF

service mariadb restart; sleep 3

mariadb <<SQL
CREATE DATABASE IF NOT EXISTS $DB;
USE $DB;
CREATE TABLE IF NOT EXISTS request_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hostname VARCHAR(50),
  client_ip VARCHAR(45),
  uri VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE USER IF NOT EXISTS 'repl'@'192.224.4.%' IDENTIFIED BY 'ReplPass123';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'192.224.4.%';
CREATE USER IF NOT EXISTS 'shibuya'@'192.224.4.%' IDENTIFIED BY 'ShibuyaPass123';
GRANT ALL PRIVILEGES ON $DB.* TO 'shibuya'@'192.224.4.%';
FLUSH PRIVILEGES;
SQL

mariadb -e "SHOW MASTER STATUS; SHOW DATABASES;"
