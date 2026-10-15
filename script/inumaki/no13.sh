#!/bin/bash
YAGA_IP="192.224.4.8"          # ISI

apt update && DEBIAN_FRONTEND=noninteractive apt install -y mariadb-server

mkdir -p /var/log/mysql && chown mysql:mysql /var/log/mysql
cat > /etc/mysql/mariadb.conf.d/99-replication.cnf <<EOF
[mysqld]
bind-address = 0.0.0.0
server-id    = 2
relay-log    = /var/log/mysql/mysql-relay-bin
EOF

service mariadb restart; sleep 3

mariadb <<SQL
STOP SLAVE;
CHANGE MASTER TO
  MASTER_HOST='$YAGA_IP',
  MASTER_USER='repl',
  MASTER_PASSWORD='ReplPass123',
  MASTER_USE_GTID=slave_pos;
START SLAVE;
SQL

sleep 3
mariadb -e "SHOW SLAVE STATUS\G" | grep -E "Master_Host|Slave_IO_Running|Slave_SQL_Running|Last_.*Error"
