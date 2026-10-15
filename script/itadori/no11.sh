#!/bin/sh
# ===== SOAL 11 — client: query dig ke Master & Slave =====
ZONE="jujutsu.K26.com"
command -v dig >/dev/null || apk add --no-cache bind-tools >/dev/null
for S in 192.224.1.2 192.224.1.3; do
  echo "================ server $S ================"
  dig @$S ${ZONE} SOA +noall +answer
  dig @$S ${ZONE} NS  +noall +answer
  dig @$S ns1.${ZONE} +short
  dig @$S ns2.${ZONE} +short
  dig @$S uji.${ZONE} TXT +short
done
echo ">>> Serial SOA di kedua server harus SAMA"
