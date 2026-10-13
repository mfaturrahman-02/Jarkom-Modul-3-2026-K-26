#!/bin/bash
L=/var/lib/dhcp/dhcpd.leases

echo "===== LEASE AKTIF (IP, MAC, mulai, selesai) ====="
awk '
/^lease /      {ip=$2; mac=""; st=""; en=""; state=""}
/starts /      {st=$3" "$4}
/ends /        {en=$3" "$4}
/binding state/{state=$3}
/hardware ethernet/ {mac=$3; sub(";","",mac)}
/^}/           {if (state=="active") print ip, mac, st, en}
' $L | sort -u

echo
echo "===== CEK IP GANDA (harus kosong) ====="
awk '
/^lease /      {ip=$2}
/binding state/{state=$3}
/^}/           {if (state=="active") print ip}
' $L | sort | uniq -d

echo
echo "===== CEK MAC GANDA PADA IP BERBEDA (info) ====="
awk '
/^lease /      {ip=$2}
/binding state/{state=$3}
/hardware ethernet/ {mac=$3}
/^}/           {if (state=="active") print mac, ip}
' $L | sort -u | awk '{c[$1]++} END{for(m in c) if(c[m]>1) print m, "punya", c[m], "IP aktif"}'

echo
echo "===== CEK IP DI LUAR KEBIJAKAN (harus kosong) ====="
awk '
/^lease /      {ip=$2}
/binding state/{state=$3}
/^}/           {if (state=="active") print ip}
' $L | sort -u | while read ip; do
  last=${ip##*.}
  net=${ip%.*}
  ok=0
  if [ "$net" = "192.224.2" ]; then
    { [ $last -ge 10 ] && [ $last -le 35 ]; } && ok=1
    { [ $last -ge 70 ] && [ $last -le 95 ]; } && ok=1
  elif [ "$net" = "192.224.3" ]; then
    { [ $last -ge 10 ] && [ $last -le 89 ]; } && ok=1
    { [ $last -ge 100 ] && [ $last -le 199 ]; } && ok=1
    [ $last -eq 99 ] && ok=1
  fi
  [ $ok -eq 0 ] && echo "DI LUAR POLICY: $ip"
done

echo
echo "===== LEASE TIME (detik) ====="
grep -E "^lease|starts|ends" $L | paste - - - | awk '{print $2, $5,$6, "->", $9,$10}' | tail -20
