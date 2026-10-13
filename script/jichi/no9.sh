#!/bin/bash
case "$1" in
  stop)
    pkill dhcrelay
    sleep 1
    echo "--- proses dhcrelay (harus kosong) ---"
    ps aux | grep [d]hcrelay
    ;;
  start)
    pkill dhcrelay 2>/dev/null; sleep 1
    dhcrelay -4 -i eth2 -i eth3 -i eth4 192.224.4.10
    sleep 1
    echo "--- proses dhcrelay (harus satu) ---"
    ps aux | grep [d]hcrelay
    ;;
  *)
    echo "pakai: bash soal8-jichi.sh stop|start"
    ;;
esac
