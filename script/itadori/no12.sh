#!/bin/sh
# ===== SOAL 12 — client: uji A, CNAME, PTR, forwarder =====
ZONE="jujutsu.K26.com"
command -v dig >/dev/null || apk add --no-cache bind-tools >/dev/null
for S in 192.224.1.2 192.224.1.3; do
  echo "================ server $S ================"
  echo "--- A record ${ZONE} ---"
  dig @$S ${ZONE} A +noall +answer
  echo "--- CNAME www.${ZONE} ---"
  dig @$S www.${ZONE} +noall +answer
  echo "--- PTR 192.224.1.4 ---"
  dig @$S -x 192.224.1.4 +noall +answer
  echo "--- Forwarder: google.com ---"
  dig @$S google.com +short | head -2
done
echo "================ resolv.conf client ================"
cat /etc/resolv.conf
echo "================ ping google.com ================"
ping -c 3 google.com
