#!/bin/bash
F=/etc/nginx/conf.d/gateway.conf
case "$1" in
  off) sed -i 's/^\(\s*\)limit_req zone/\1#limit_req zone/' $F ;;
  on)  sed -i 's/^\(\s*\)#limit_req zone/\1limit_req zone/' $F ;;
  *)   echo "pakai: bash ratelimit.sh on|off"; exit 1 ;;
esac
nginx -t && service nginx reload
grep -n limit_req $F
