# PRAKTIKUM JARKOM MODUL 3 K 26 - 2026

## Angota Kelompok

| Nama                         | NRP        |
| ---------------------------- | ---------- |
| Az Zahra Fiddien Al Farabi          | 5027251021 |
| Muhammad Faturrahman | 5027241065 |

## Laporan
1. Ketika Curtain menutup Shibuya, jalur komunikasi antar zona Jujutsu High terputus. Pulihkan konektivitas dasar dengan mengonfigurasi jichi: eth0 memperoleh WAN dari NAT, sedangkan eth1–eth4 menjadi gateway Network 1–4 sesuai tabel pemetaan. Aktifkan IPv4 forwarding dan source NAT, lalu tetapkan IP statis host infrastruktur sesuai tabel spesifikasi. Buktikan konektivitas setiap host ke gateway dan akses eksternal dari host yang relevan. 

Pembagian Jaringan

| Network | Subnet | Gateway (jichi) | Interface jichi | Host |
| --- | --- | --- | --- | --- |
| Network 1 | `192.224.1.0/24` | `192.224.1.1` | `eth1` | utahime, shoko, gojo |
| Network 2 | `192.224.2.0/24` | `192.224.2.1` | `eth2` | itadori, fusiguro, zenin, okkotsu |
| Network 3 | `192.224.3.0/24` | `192.224.3.1` | `eth3` | ino, kusakabe, kugisaki, miwa |
| Network 4 | `192.224.4.0/24` | `192.224.4.1` | `eth4` | geto, maki, panda, nanami, todo, kirara, tengen, yaga, inumaki |

Pembagian jaringan untuk host:
| Network | Subnet Prefix | Interface Router (jichi) | Gateway | Nama Host | Tipe / Image | IP Address |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Network 1** | 192.224.1.0/24 | eth1 | 192.224.1.1 | utahime | Debian (Infrastruktur) | 192.224.1.2/24 |
| | | | | shoko | Debian (Infrastruktur) | 192.224.1.3/24 |
| | | | | gojo | Debian (Infrastruktur) | 192.224.1.4/24 |
| **Network 4** | 192.224.4.0/24 | eth4 | 192.224.4.1 | geto | Debian (Infrastruktur) | 192.224.4.2/24 |
| | | | | maki | Debian (Infrastruktur) | 192.224.4.3/24 |
| | | | | panda | Debian (Infrastruktur) | 192.224.4.4/24 |
| | | | | nanami | Debian (Infrastruktur) | 192.224.4.5/24 |
| | | | | todo | Debian (Infrastruktur) | 192.224.4.6/24 |
| | | | | kirara | Debian (Infrastruktur) | 192.224.4.7/24 |
| | | | | tengen | Debian (Infrastruktur) | 192.224.4.10/24 |
| | | | | yaga | Debian (Infrastruktur) | 192.224.4.8/24 |
| | | | | inumaki | Debian (Infrastruktur) | 192.224.4.9/24 |


**Untuk Network 1**

`utahime`:

<img width="587" height="217" alt="Screenshot 2026-10-13 150444" src="https://github.com/user-attachments/assets/611185a5-2c8d-45b1-b2a8-cdb3fcf387ef" />

`shoko`:

<img width="610" height="287" alt="Screenshot 2026-10-13 150530" src="https://github.com/user-attachments/assets/d7d80db5-0bb8-4060-9afb-1768b12b15f9" />

**Untuk Network 2**

`geto`:

<img width="602" height="234" alt="Screenshot 2026-10-13 150500" src="https://github.com/user-attachments/assets/803f3f93-7bf8-48ab-8556-9ecca6a9810a" />

`tengen`:

<img width="547" height="220" alt="Screenshot 2026-10-13 150510" src="https://github.com/user-attachments/assets/d3a19da8-0e0c-4e5b-ba0b-cb6a8db7c807" />


2. Tengen, penjaga pusat distribusi di Data Center, harus mengambil alih pengalokasian alamat bagi wilayah yang membutuhkan konfigurasi dinamis. Konfigurasikan isc-dhcp-server pada [PREFIX IP].4.10. Deklarasikan Network 4 ([PREFIX IP].4.0/24) sebagai subnet lokal tanpa pool dinamis, lalu siapkan scope DHCP untuk Network 2 ([PREFIX IP].2.0/24) dan Network 3 ([PREFIX IP].3.0/24). Validasi konfigurasi dan pastikan service aktif tanpa error “No subnet declaration”.

Memperbarui daftar paket dan memasang isc-dhcp-server:
```
apt-get update
apt-get install isc-dhcp-server -y
```

nano /etc/default/isc-dhcp-server:
tambahkan `INTERFACESv4="eth0"`

nano /etc/dhcp/dhcpd.conf:
Deklarasi subnet yang digunakan
```
# Network 4: subnet lokal tanpa pool dinamis
subnet 192.224.4.0 netmask 255.255.255.0 {
}

# Network 2: scope DHCP
subnet 192.224.2.0 netmask 255.255.255.0 {
}

# Network 3: scope DHCP
subnet 192.224.3.0 netmask 255.255.255.0 {
}
```
Menyiapkan direktori dan file database lease DHCP:
```
mkdir -p /var/lib/dhcp
touch /var/lib/dhcp/dhcpd.leases
chmod 644 /var/lib/dhcp/dhcpd.leases
```

Memeriksa sintaks konfigurasi DHCP:
```
dhcpd -t -cf /etc/dhcp/dhcpd.conf
```

<img width="1021" height="223" alt="image" src="https://github.com/user-attachments/assets/202da8bb-5a5d-4f92-8544-b103ec586cc0" />

Memeriksa deklarasi subnet:
```
grep -nE '^[[:space:]]*subnet ' /etc/dhcp/dhcpd.conf
```

<img width="1309" height="121" alt="image" src="https://github.com/user-attachments/assets/2dffaf57-15b2-470d-9980-e009bd2a25c1" />

DHCP Server dijalankan secara langsung:
```
dhcpd -4 -cf /etc/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid eth0
```
Memeriksa proses DHCP Server:
```
ps aux | grep '[d]hcpd'
```

<img width="1711" height="87" alt="image" src="https://github.com/user-attachments/assets/bed788a3-2ad1-4816-9a15-d22ee6e5ef73" />


3. Permintaan alamat dari Divisi A dan Divisi B tidak dapat menyeberangi subnet secara langsung. Konfigurasikan jichi sebagai DHCP Relay menuju tengen ([PREFIX IP].4.10), menggunakan eth2 untuk Network 2 dan eth3 untuk Network 3. Buktikan bahwa client dari kedua subnet berhasil memperoleh lease melalui relay.

Instal DHCP Relay di jichi:
```
apt-get update
apt-get install isc-dhcp-relay -y
```

Jalankan DHCP Relay:
```
dhcrelay -4 -d -i eth2 -i eth3 192.224.4.10
```

**Untuk Network 2**

Tes koneksi client ke gateway `itadori (Network 2)`:

<img width="436" height="80" alt="image" src="https://github.com/user-attachments/assets/dfa1721b-b6c4-495a-8490-094ce29815a4" />

Uji DHCP Relay `itadori (Network 2)`:

<img width="521" height="211" alt="image" src="https://github.com/user-attachments/assets/6ba00a7c-2d86-4c73-ab93-ae3a7b66184e" />

**Untuk Network 3**
Tes koneksi client ke gateway `ino (Network 3)`:

<img width="460" height="116" alt="image" src="https://github.com/user-attachments/assets/e5d19c39-fa50-467c-97f6-1d678f9c8438" />

Uji DHCP Relay `ino (Network 3)`:

<img width="517" height="68" alt="image" src="https://github.com/user-attachments/assets/af75e69b-25a1-4134-bcc7-2beb0af7f6c4" />

4. Agar tim Dev dan Support di Divisi A menerima jatah alamat yang berbeda, atur dua pool DHCP pada Network 2. Tetapkan Pool 1 ([PREFIX IP].2.10–[PREFIX IP].2.35) untuk itadori dan fushiguro, serta Pool 2 ([PREFIX IP].2.70–[PREFIX IP].2.95) untuk zenin dan okkotsu. Rentang [PREFIX IP].2.36–[PREFIX IP].2.69 tidak boleh dialokasikan. Karena seluruh client berada pada subnet yang sama, gunakan DHCP class berdasarkan MAC Address atau Client ID untuk memisahkan kedua kelompok.
   
Jalankan perintah berikut pada masing-masing client, yaitu `itadori, fusiguro, zenin, dan okkotsu,` untuk mendapatkan MAC address interface eth0. Catat hasilnya sesuai nama client. 

```
cat /sys/class/net/eth0/address
```
Pada node tengen, buka file konfigurasi DHCP menggunakan perintah:
```
nano /etc/dhcp/dhcpd.conf
```
Tambahkan konfigurasi class berikut untuk mengelompokkan client berdasarkan MAC address:
```
class "pool1" {
    match hardware;
}

class "pool2" {
    match hardware;
}

subclass "pool1" 1:02:42:ba:83:83:00;
subclass "pool1" 1:02:42:03:25:97:00;

subclass "pool2" 1:02:42:e7:5c:5f:00;
subclass "pool2" 1:02:42:79:b8:e1:00;
```
Pool 1 digunakan oleh itadori dan fusiguro, sedangkan Pool 2 digunakan oleh zenin dan okkotsu.

Mengonfigurasi Pool IP Network 2:
Tambahkan konfigurasi subnet Network 2 berikut ke dalam file /etc/dhcp/dhcpd.conf.
```
subnet 192.224.2.0 netmask 255.255.255.0 {
    option routers 192.224.2.1;

    pool {
        range 192.224.2.10 192.224.2.35;
        allow members of "pool1";
    }

    pool {
        range 192.224.2.70 192.224.2.95;
        allow members of "pool2";
    }
}
```
Pool 1 memiliki rentang IP 192.224.2.10–192.224.2.35, sedangkan Pool 2 memiliki rentang IP 192.224.2.70–192.224.2.95. Rentang 192.224.2.36–192.224.2.69 tidak dialokasikan ke pool mana pun.

Pastikan konfigurasi subnet Network 1 tetap tersedia dan pertahankan konfigurasi sementara Network 3 berikut:
```
subnet 192.224.3.0 netmask 255.255.255.0 {
    range 192.224.3.10 192.224.3.89;
    option routers 192.224.3.1;
}
```

Jalankan DHCP server menggunakan konfigurasi yang telah diperbarui.
```
dhcpd -4 -cf /etc/dhcp/dhcpd.conf eth0
```
Periksa apakah proses DHCP server sudah berjalan.
```
ps aux | grep '[d]hcpd'
```

Jalankan di setiap Client Network 2:
```
udhcpc -i eth0
ip -br addr
```

- client 1 `itadori`

  <img width="663" height="190" alt="Screenshot 2026-10-13 191408" src="https://github.com/user-attachments/assets/bf9a4e47-f4ea-4fe6-9544-2a006c991161" />

- client 2 `fusigiro`

  <img width="512" height="153" alt="Screenshot 2026-10-13 191752" src="https://github.com/user-attachments/assets/0831b900-cab1-4590-a54f-ffc54b6b1395" />

- client 3 `zenin`

  <img width="668" height="154" alt="Screenshot 2026-10-13 191355" src="https://github.com/user-attachments/assets/568833ad-7509-425c-a242-13497cc1086f" />
  
- client 4 `okkotsu`

  <img width="543" height="149" alt="Screenshot 2026-10-13 191455" src="https://github.com/user-attachments/assets/f81528ff-aab1-409e-9589-9db84aa47508" />

5. Setiap tim lapangan memiliki durasi operasi yang berbeda. Pada Network 3, berikan short lease 30 menit (1800 detik) kepada ino dan kusakabe, serta long lease 12 jam (43200 detik) kepada miwa. Gunakan pool short lease [PREFIX IP].3.10–[PREFIX IP].3.89 dan pool long lease [PREFIX IP].3.100–[PREFIX IP].3.199. Sesuaikan default-lease-time dan max-lease-time untuk setiap kelas client. Berikan pula DHCP options berupa DNS [PREFIX IP].1.2 dan [PREFIX IP].1.3, serta domain-search <xxxx>.com.
Jalankan perintah berikut pada client ino, kusakabe, dan miwa, catat hasilnya.
```
cat /sys/class/net/eth0/address
```
Tambahkan konfigurasi berikut pada /etc/dhcp/dhcpd.conf untuk membedakan durasi lease setiap kelompok client:
```
class "short" {
    match hardware;
    default-lease-time 1800;
    max-lease-time 1800;
}

class "long" {
    match hardware;
    default-lease-time 43200;
    max-lease-time 43200;
}

subclass "short" 1:02:42:30:35:07:00;
subclass "short" 1:02:42:ac:77:cb:00;
subclass "long" 1:02:42:8a:f5:1e:00;
```
Sesuaikan blok subnet Network 3 menjadi berikut:
```
subnet 192.224.3.0 netmask 255.255.255.0 {
    option routers 192.224.3.1;
    option subnet-mask 255.255.255.0;
    option broadcast-address 192.224.3.255;

    pool {
        range 192.224.3.10 192.224.3.89;
        allow members of "short";
    }

    pool {
        range 192.224.3.100 192.224.3.199;
        allow members of "long";
    }
}
```
Tambahkan opsi DNS dan domain-search pada bagian global konfigurasi, di luar blok subnet. Opsi ini menetapkan DNS server, domain pencarian, dan parameter DHCP yang diminta client:

```
option domain-name-servers 192.224.1.2, 192.224.1.3;
option domain-search "K26.com";
option dhcp-parameter-request-list = concat(option dhcp-parameter-request-list, 77);
```
Setelah konfigurasi selesai, validasi terlebih dahulu:
```
dhcpd -t -cf /etc/dhcp/dhcpd.conf
```
Jika validasi berhasil, konfigurasi perlu dimuat ulang agar perubahan diterapkan. Namun, ISC DHCP Server tidak selalu mendukung reload langsung. Periksa dukungan layanan yang digunakan sebelum menerapkan perubahan. Periksa proses DHCP server yang sedang berjalan:
```
ps aux | grep '[d]hcpd'
```
jalankan di setiap client `ino, kusakabe, miwa`: 
```
pkill udhcpc
ip addr flush dev eth0
udhcpc -i eth0 -O search -n -q
ip addr show eth0 | grep inet
cat /etc/resolv.conf
```

- client `ino`:

  <img width="996" height="349" alt="image" src="https://github.com/user-attachments/assets/602e3c8d-a2eb-48c4-a9e5-c5de4f3aac0e" />

- client `kusakabe`:
  
  <img width="999" height="355" alt="image" src="https://github.com/user-attachments/assets/7f4dc924-6a1e-4ece-8525-d2a024bbd21d" />

- client `miwa`:

  <img width="1147" height="349" alt="image" src="https://github.com/user-attachments/assets/c9638dfa-4733-4f11-85a0-5c054b1176c6" />

6. Kugisaki ditetapkan sebagai personel VIP yang harus mempertahankan alamat yang sama setiap kali terhubung. Buat DHCP static lease berdasarkan MAC Address client tersebut dengan fixed address [PREFIX IP].3.99. Pastikan alamat ini berada di luar seluruh pool dinamis, validasi konfigurasi server, lalu renew lease pada client. Buktikan bahwa alamat yang diterima sesuai dengan reservasi.

Pastikan node kugisaki dalam keadaan running, lalu jalankan perintah berikut pada node tersebut:
```
cat /sys/class/net/eth0/address
```
MAC address untuk client kugisaki adalah `02:42:22:ab:0c:00`

Pada node tengen, buka file konfigurasi DHCP:
```
nano /etc/dhcp/dhcpd.conf
```

Tambahkan blok host berikut di luar blok subnet 
```
host kugisaki {
    hardware ethernet 02:42:22:ab:0c:00;
    fixed-address 192.224.3.99;
}
```

Selanjutnya, validasi konfigurasi di tengen:
```
dhcpd -t -cf /etc/dhcp/dhcpd.conf
```

Jika validasi berhasil, terapkan perubahan melalui mekanisme reload DHCP yang tersedia. Setelah konfigurasi aktif, jalankan di kugisaki:
```
udhcpc -i eth0
ip addr show eth0 | grep inet
ip route
cat /etc/resolv.conf
```

- Bukti pada client `kugisaki`

<img width="750" height="188" alt="Screenshot 2026-10-13 195706" src="https://github.com/user-attachments/assets/27358c43-9c78-4f35-a3d6-85eb54ac4ce3" />

7. Setelah aturan alokasi diterapkan, pastikan setiap client menerima konfigurasi jaringan sesuai wilayahnya: subnet mask 255.255.255.0 (/24), gateway dan broadcast address yang benar, DNS [PREFIX IP].1.2 serta [PREFIX IP].1.3, dan domain-search yang ditentukan. Periksa IP address dan routing seluruh client Divisi A dan Divisi B, kemudian cocokkan lease dengan /var/lib/dhcp/dhcpd.leases pada tengen. Pastikan tidak ada alamat yang bertabrakan atau berada di luar kebijakan pool.

Jalankan perintah berikut untuk memeriksa IP address, subnet mask, broadcast address, gateway, routing, DNS, dan domain-search pada setiap client.
```
ip -4 addr show eth0 | grep inet
ip route
cat /etc/resolv.conf
```

Menguji Konektivitas ke Gateway. Pastikan ping berhasil dan tidak terdapat packet loss:
Client Network 2 `ping -c 2 192.224.2.1`
Client Network 3 `ping -c 2 192.224.3.1`

- Client `itadori` Network 2

<img width="525" height="280" alt="image" src="https://github.com/user-attachments/assets/b7cea16f-dac3-4e78-a84c-eb514186095e" />

- Client `fusiguro` Network 2

<img width="506" height="274" alt="image" src="https://github.com/user-attachments/assets/0f95e9b1-9dd0-4e9c-a35c-a1584bfba1d3" />

- Client `zenin` Network 2

<img width="622" height="274" alt="image" src="https://github.com/user-attachments/assets/2c1d2a16-7e44-4a89-ac11-e226af5a3d52" />

- Client `okkotsu` Network 2

<img width="517" height="275" alt="image" src="https://github.com/user-attachments/assets/64e6fa72-b615-4c79-a0c3-2e3fcdd14a4f" />

- Client `ino` Network 3

<img width="485" height="290" alt="image" src="https://github.com/user-attachments/assets/c477648c-c3a3-425b-b9cf-e7e09d358c2b" />

- Client `kusakabe` Network 3

<img width="562" height="284" alt="image" src="https://github.com/user-attachments/assets/605ef084-d7e8-4ea9-a684-2e91bdd610b0" />

- Client `kugisaki` Network 3

<img width="507" height="275" alt="image" src="https://github.com/user-attachments/assets/376eb136-ecec-4548-8904-0dd3bf9211a6" />

- Client `miwa` Network 3

<img width="587" height="281" alt="image" src="https://github.com/user-attachments/assets/dfc31456-f9aa-4c3e-b3ec-bc8caca97c9b" />

8. Sebelum Curtain dibuka kembali, buktikan bahwa proses pemberian alamat berjalan sesuai protokol. Lakukan packet capture saat salah satu client Network 2 atau Network 3 meminta lease baru. Gunakan tcpdump pada tengen atau jalur menuju Data Center untuk menunjukkan urutan DHCPDISCOVER → DHCPOFFER → DHCPREQUEST → DHCPACK. Identifikasi alamat server, alamat yang diberikan, lease time, dan field giaddr. Pastikan nilai giaddr sesuai dengan interface jichi yang menerima request dari subnet client.

Periksa proses DHCP server pada tengen:
```
ps aux | grep '[d]hcpd'
```
Periksa proses DHCP relay pada jichi:
```
ps aux | grep '[d]hcrelay'
```
Pastikan relay menggunakan interface eth2, eth3, dan eth4.

Mulai packet capture pada tengen, jalankan perintah berikut pada tengen untuk merekam paket DHCP melalui eth0:
```
tcpdump -ni eth0 -w /root/dhcp.pcap 'port 67 or port 68'
```
Biarkan capture berjalan selama client meminta lease baru.

Di itadori, jalankan ulang permintaan lease saat capture berlangsung:
```
pkill udhcpc 2>/dev/null
ip addr flush dev eth0
ip link set eth0 up
udhcpc -i eth0 -n
```

<img width="498" height="164" alt="image" src="https://github.com/user-attachments/assets/a2426bfb-7d0b-4d48-b882-0c43c2807f80" />

Kembali ke tengen, lalu baca hasil capture:
```
tcpdump -nn -vvv -r /root/dhcp.pcap 'port 67 or port 68'
```

<img width="1423" height="496" alt="image" src="https://github.com/user-attachments/assets/4fcffe22-bd57-4f1b-80f1-b9ddfd7f736f" />

<img width="1568" height="659" alt="image" src="https://github.com/user-attachments/assets/e0404ca0-05d6-4b07-93a4-c0a9a5018d82" />

<img width="1568" height="597" alt="image" src="https://github.com/user-attachments/assets/9b225f74-1f27-4ed1-9ea4-478b9de61830" />

9. Sebuah gangguan memutus jalur relay dan membuat permintaan alamat tidak sampai ke Data Center. Hentikan service DHCP Relay pada jichi, lalu paksa salah satu client di Network 2 atau Network 3 meminta lease baru dan catat gejalanya. Pulihkan service relay, ulangi permintaan DHCP, lalu buktikan bahwa client kembali memperoleh alamat dari pool yang benar dengan gateway semula.

Pada client itadori, jalankan perintah berikut:
```
ip -br addr show eth0
ip route
ping -c 2 192.224.2.1
```
Matikan DHCP relay pada jichi:
```
pkill dhcrelay
sleep 1
ps aux | grep '[d]hcrelay'
```
Pastikan proses dhcrelay sudah tidak berjalan.

Periksa kondisi jaringan saat relay mati:
```
ip -br addr show eth0
ip route
```

<img width="1066" height="327" alt="image" src="https://github.com/user-attachments/assets/cff7987a-bbff-4c90-a5b1-dcfc51272f29" />

Aktifkan kembali DHCP relay pada jichi.
```
dhcrelay -4 -i eth2 -i eth3 -i eth4 192.224.4.10
```
Biarkan proses relay tetap berjalan. Periksa prosesnya dari terminal lain:
```
ps aux | grep '[d]hcrelay'
```

Kembali ke itadori, jalankan:
```
pkill udhcpc 2>/dev/null
ip addr flush dev eth0
ip link set eth0 up
udhcpc -i eth0 -n -t 3 -T 2
```
Verifikasi pemulihan jaringan:
```
ip -br addr show eth0
ip route
ping -c 2 192.224.2.1
```

<img width="898" height="495" alt="image" src="https://github.com/user-attachments/assets/7b02448b-1aa0-4965-8800-d5ec6d10d3f9" />

10. Setelah gangguan Shibuya tertangani, pastikan pemulihan bertahan setelah restart. Aktifkan autostart DHCP Server pada tengen dan DHCP Relay pada jichi, lalu restart kedua node. Verifikasi status layanan, IP, gateway, lease, dan konektivitas client Network 2–3. Pastikan kebijakan Pool 1, Pool 2, short lease, long lease, dan fixed address tetap berlaku.
    
Pada tengen, periksa interface DHCP Server:
```
cat /etc/default/isc-dhcp-server
```
Pastikan terdapat INTERFACESv4="eth0". Selanjutnya, validasi konfigurasi DHCP:
```
dhcpd -t -cf /etc/dhcp/dhcpd.conf
```
Pastikan konfigurasi mencakup Pool 1, Pool 2, short lease, long lease, dan fixed address kugisaki.

Pada jichi, periksa konfigurasi DHCP Relay:
```
cat /etc/default/isc-dhcp-relay
```
Pastikan relay menggunakan eth2 dan eth3 sebagai interface sisi client serta eth4 sebagai interface sisi server, dengan server DHCP 192.224.4.10.

Pada tengen, hentikan proses DHCP Server yang berjalan manual:
```
pkill dhcpd
sleep 2
rm -f /var/run/dhcpd.pid
```

Pada jichi, hentikan proses DHCP Relay yang berjalan manual:
```
pkill dhcrelay
sleep 1
```
Langkah ini mencegah bentrokan antara proses manual dan service yang akan dijalankan.

Lalu aktifkan autostart layanan sehingg pada tengen, jika menggunakan systemd:
```
systemctl enable isc-dhcp-server
systemctl is-enabled isc-dhcp-server
service isc-dhcp-server restart
service isc-dhcp-server status
```
Pada jichi, jalankan:
```
systemctl enable isc-dhcp-relay
systemctl is-enabled isc-dhcp-relay
service isc-dhcp-relay restart
service isc-dhcp-relay status
```

Kemudian pastikan konfigurasi IP tersimpan secara permanen. Pada tengen dan jichi, periksa alamat IP serta routing dengan
```
ip -br addr
ip route
```
Pastikan alamat IP server dan seluruh interface jichi tersimpan dalam konfigurasi jaringan permanen yang digunakan node. 
Setelah itu lakukan restart.

Selanjutnya lakukan verifikasi  pada `tengen` dan `jichi` setelah restart. Pastikan kedua service aktif, alamat IP tidak berubah, dan konektivitas berjalan dengan baik.
Pada `tengen`:
```
service isc-dhcp-server status
ps aux | grep '[d]hcpd'
ip -br addr show eth0
ip route
ping -c 2 192.224.4.1
```
Pada `jichi`:
```
service isc-dhcp-relay status
ps aux | grep '[d]hcrelay'
ip -br addr
ip route
ping -c 2 192.224.4.10
```
Lakukan verifikasi terhadap salah satu client di network 2 dan 3, dengan jalankan:
```
pkill udhcpc
ip addr flush dev eth0
udhcpc -i eth0 -O search -n -q
ip -4 addr show eth0 | grep inet
ip route
ping -c 2 192.224.1.2
```
Pada `itadori` Network 2:

<img width="527" height="274" alt="Screenshot 2026-10-14 123550" src="https://github.com/user-attachments/assets/cd290101-d7e9-4cf4-bbd2-d7f58a73682a" />

Pada `Zenin` Network 2:

<img width="598" height="274" alt="Screenshot 2026-10-14 123611" src="https://github.com/user-attachments/assets/d5f39264-4f6c-4aee-a916-063364cf7704" />

Pada `ino` Network 3:

<img width="578" height="271" alt="Screenshot 2026-10-14 123629" src="https://github.com/user-attachments/assets/f30de603-fc73-4fbf-a2c9-2eda81ab4578" />

Pada `kugisaki` Network 3:

<img width="543" height="272" alt="Screenshot 2026-10-14 123649" src="https://github.com/user-attachments/assets/106cb81e-9b6c-4f9d-bd71-a72d5b277022" />

11. Utahime dan Shoko ditugaskan membangun sistem penamaan domain resmi agar seluruh pos tidak perlu menghafal alamat IP mentah. Konfigurasikan BIND9 pada utahime sebagai DNS Master dan shoko sebagai DNS Slave untuk mengelola domain jujutsu.<xxxx>.com. Atur SOA record, NS delegasi untuk kedua server, dan terapkan allow-transfer dari Master ke Slave. Pastikan file zona berhasil tersinkronisasi otomatis ke shoko saat nomor serial di utahime dinaikkan, lalu buktikan dengan melakukan query dig ke kedua server dari salah satu client.

**Pada bagian utahime (DNS Master)**

Lakukan install BIND9 terlebih dahulu dengan menjalankan pada node utahime:
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -o Acquire::AllowInsecureRepositories=true
DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated bind9 bind9-utils dnsutils
```
Periksa apakah program telah terpasang:
```
command -v named
command -v named-checkconf
command -v dig
```
Ketiga perintah harus menampilkan lokasi executable.
Kemudian buat direktori zona
```
mkdir -p /etc/bind/zones
```
Konfigurasikan opsi BIND9:
```
cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    dnssec-validation no;
    recursion yes;
    allow-query { any; };
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF
```
Deklarasikan zona Master:
```
cat > /etc/bind/named.conf.local <<'EOF'
zone "jujutsu.K26.com" {
    type master;
    file "/etc/bind/zones/db.jujutsu.K26.com";
    allow-transfer { 192.224.1.3; };
    also-notify { 192.224.1.3; };
    notify yes;
};
EOF
```
Buat file zona:
```
cat > /etc/bind/zones/db.jujutsu.K26.com <<'EOF'
$TTL 604800
@       IN  SOA ns1.jujutsu.K26.com. root.jujutsu.K26.com. (
                2026101401 ; Serial
                3600       ; Refresh
                600        ; Retry
                2419200    ; Expire
                604800 )   ; Negative Cache TTL

@       IN  NS      ns1.jujutsu.K26.com.
@       IN  NS      ns2.jujutsu.K26.com.
ns1     IN  A       192.224.1.2
ns2     IN  A       192.224.1.3
EOF
```
Validasi konfigurasi dan zona dengan menjalankan:
```
named-checkconf
named-checkzone jujutsu.K26.com /etc/bind/zones/db.jujutsu.K26.com
```

<img width="616" height="73" alt="Screenshot 2026-10-14 132459" src="https://github.com/user-attachments/assets/7f01ef0a-2373-49ef-bd06-95e26fd53466" />

Jalankan DNS Master:
```
service bind9 restart
service bind9 status
```
Lakukan pengujian:
```
dig @127.0.0.1 jujutsu.K26.com SOA +short
dig @127.0.0.1 jujutsu.K26.com NS +short
```
<img width="1066" height="142" alt="image" src="https://github.com/user-attachments/assets/82990d8c-c796-4f6a-aa86-fc7b9209f95c" />

**Pada bagian shoko (DNS Slave)**

Lakukan install BIND9 terlebih dahulu dengan menjalankan pada node `shoko`:
```
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update -o Acquire::AllowInsecureRepositories=true
DEBIAN_FRONTEND=noninteractive apt-get install -y --allow-unauthenticated bind9 bind9-utils dnsutils
```
Periksa apakah program telah terpasang:
```
command -v named
command -v named-checkconf
command -v dig
```
Ketiga perintah harus menampilkan lokasi executable.
Konfigurasikan opsi BIND9:
```
cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    dnssec-validation no;
    recursion yes;
    allow-query { any; };
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF
```
Deklarasikan zona Slave:
```
cat > /etc/bind/named.conf.local <<'EOF'
zone "jujutsu.K26.com" {
    type slave;
    masters { 192.224.1.2; };
    file "/var/lib/bind/db.jujutsu.K26.com";
};
EOF
```
Validasi konfigurasi dan zona dengan menjalankan:
```
named-checkconf
named-checkzone jujutsu.K26.com /etc/bind/zones/db.jujutsu.K26.com
```
Jalankan DNS Slave:
```
service bind9 restart
service bind9 status
```
Tunggu beberapa saat, lalu periksa file zona:
```
ls -l /var/lib/bind/
```
Uji SOA dari Shoko:
```
dig @127.0.0.1 jujutsu.K26.com SOA +short
```

<img width="613" height="87" alt="Screenshot 2026-10-14 132554" src="https://github.com/user-attachments/assets/67e492c1-1732-431a-bd26-d4d1f0b6eb9b" />

**Uji sinkronisasi otomatis**

Periksa serial saat ini terlebih dahulu:
```
grep -A5 'SOA' /etc/bind/zones/db.jujutsu.K26.com
```
Jika serial masih 2026101401, naikkan menjadi 2026101402 dan tambahkan record TXT:
```
sed -i 's/2026101401/2026101402/' /etc/bind/zones/db.jujutsu.K26.com
echo 'uji IN TXT "serial-2026101402"' >> /etc/bind/zones/db.jujutsu.K26.com
```
Jika serial sudah berbeda, gunakan serial baru yang lebih besar dari serial sebelumnya.
Validasi dan reload zona Master:
```
named-checkzone jujutsu.K26.com /etc/bind/zones/db.jujutsu.K26.com
rndc reload jujutsu.K26.com
```
Pastikan validasi menunjukkan OK.
Periksa sinkronisasi di kedua server dengan menjalankan:
Pada `Utahime`
```
dig @127.0.0.1 jujutsu.K26.com SOA +short
dig @127.0.0.1 uji.jujutsu.K26.com TXT +short
```

<img width="526" height="68" alt="image" src="https://github.com/user-attachments/assets/c09073ea-8bcf-4bd6-9bca-2ef2230a770c" />

Pada `Shoko`
```
dig @192.224.1.3 jujutsu.K26.com SOA +short
dig @192.224.1.3 uji.jujutsu.K26.com TXT +short
```

<img width="571" height="42" alt="image" src="https://github.com/user-attachments/assets/637a4a71-397f-4b4a-be0d-932b6cc38460" />

**Uji query dari client Itadori**

Lakukan pengujian dari client itadori.
Pastikan client terhubung ke jaringan
```
ip -br addr show eth0
ip route
```
Uji query ke DNS Master:
```
dig @192.224.1.2 jujutsu.K26.com SOA +noall +answer
dig @192.224.1.2 jujutsu.K26.com NS +noall +answer
dig @192.224.1.2 uji.jujutsu.K26.com TXT +short
```
Uji Query ke DNS Slave:
```
dig @192.224.1.3 jujutsu.K26.com SOA +noall +answer
dig @192.224.1.3 jujutsu.K26.com NS +noall +answer
dig @192.224.1.3 uji.jujutsu.K26.com TXT +short
```

<img width="825" height="215" alt="Screenshot 2026-10-14 133351" src="https://github.com/user-attachments/assets/33055c7c-2864-4570-8119-601891c6a6ea" />

12. Peta domain harus memetakan pintu masuk utama dan tetap bisa mencari alamat di luar kawasan Shibuya. Pada utahime, buat A record jujutsu.<xxxx>.com yang mengarah ke gojo, serta CNAME www yang merujuk ke domain utama tersebut. Buat pula Reverse DNS (zona PTR) untuk melacak IP gojo kembali ke domain resminya, dan aktifkan fitur DNS Forwarder pada BIND9 mengarah ke IP gateway internet (192.168.122.1). Uji dari client dengan dig untuk mengecek CNAME, PTR, dan buktikan client tetap bisa melakukan ping ke domain internet seperti google.com.

**Pada utahime (DNS Master)**

Cek serial zona saat ini:
```
grep Serial /etc/bind/zones/db.jujutsu.K26.com
```
Serial baru di langkah berikutnya harus lebih besar dari angka ini. Contoh di bawah memakai 2026101403, dengan asumsi serial sebelumnya 2026101402 (hasil Soal 11).
Aktifkan DNS Forwarder ke gateway internet:
```
cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    forward only;
    dnssec-validation no;
    recursion yes;
    allow-query { any; };
    allow-recursion { any; };
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF
```
Tambahkan zona reverse di samping zona forward. Keduanya ditransfer ke shoko:
```
cat > /etc/bind/named.conf.local <<'EOF'
zone "jujutsu.K26.com" {
    type master;
    file "/etc/bind/zones/db.jujutsu.K26.com";
    allow-transfer { 192.224.1.3; };
    also-notify { 192.224.1.3; };
    notify yes;
};
zone "1.224.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.1.224.192.in-addr.arpa";
    allow-transfer { 192.224.1.3; };
    also-notify { 192.224.1.3; };
    notify yes;
};
EOF
```
Perbarui zona forward dengan A record ke gojo dan CNAME www:
```
cat > /etc/bind/zones/db.jujutsu.K26.com <<'EOF'
$TTL 604800
@       IN  SOA ns1.jujutsu.K26.com. root.jujutsu.K26.com. (
                2026101403 ; Serial
                3600       ; Refresh
                600        ; Retry
                2419200    ; Expire
                604800 )   ; Negative Cache TTL
;
@       IN  NS      ns1.jujutsu.K26.com.
@       IN  NS      ns2.jujutsu.K26.com.
ns1     IN  A       192.224.1.2
ns2     IN  A       192.224.1.3
@       IN  A       192.224.1.4
www     IN  CNAME   jujutsu.K26.com.
EOF

Buat zona reverse yang berisi PTR untuk gojo:

cat > /etc/bind/zones/db.1.224.192.in-addr.arpa <<'EOF'
$TTL 604800
@       IN  SOA ns1.jujutsu.K26.com. root.jujutsu.K26.com. (
                2026101403 ; Serial
                3600       ; Refresh
                600        ; Retry
                2419200    ; Expire
                604800 )   ; Negative Cache TTL
;
@       IN  NS      ns1.jujutsu.K26.com.
@       IN  NS      ns2.jujutsu.K26.com.
4       IN  PTR     jujutsu.K26.com.
2       IN  PTR     ns1.jujutsu.K26.com.
3       IN  PTR     ns2.jujutsu.K26.com.
EOF
```
Validasi konfigurasi dan kedua zona:
```
named-checkconf
named-checkzone jujutsu.K26.com /etc/bind/zones/db.jujutsu.K26.com
named-checkzone 1.224.192.in-addr.arpa /etc/bind/zones/db.1.224.192.in-addr.arpa
```
Pastikan kedua zona menampilkan loaded serial 2026101403 dan OK.

Restart BIND9:
```
pkill named 2>/dev/null; sleep 1
service named start 2>/dev/null || named -u bind
sleep 2
ps aux | grep '[n]amed'
```
Uji secara lokal:
```
dig @127.0.0.1 jujutsu.K26.com +short
dig @127.0.0.1 www.jujutsu.K26.com +short
dig @127.0.0.1 -x 192.224.1.4 +short
dig @127.0.0.1 google.com +short
```

<img width="428" height="164" alt="Screenshot 2026-10-14 134529" src="https://github.com/user-attachments/assets/fc108ae7-a4d0-4cec-af83-1ddbc750438b" />

Pastikan A record mengarah ke 192.224.1.4, CNAME www mengarah ke jujutsu.K26.com., PTR mengarah ke jujutsu.K26.com., dan google.com mendapat IP lewat forwarder.

**Pada Shoko (DNS Slave)**

Aktifkan DNS Forwarder:
```
cat > /etc/bind/named.conf.options <<'EOF'
options {
    directory "/var/cache/bind";
    forwarders { 192.168.122.1; };
    forward only;
    dnssec-validation no;
    recursion yes;
    allow-query { any; };
    allow-recursion { any; };
    listen-on { any; };
    listen-on-v6 { none; };
};
EOF
```
Tambahkan zona reverse sebagai slave:
```
cat > /etc/bind/named.conf.local <<'EOF'
zone "jujutsu.K26.com" {
    type slave;
    masters { 192.224.1.2; };
    file "/var/lib/bind/db.jujutsu.K26.com";
};

zone "1.224.192.in-addr.arpa" {
    type slave;
    masters { 192.224.1.2; };
    file "/var/lib/bind/db.1.224.192.in-addr.arpa";
};
EOF
```
Validasi konfigurasi dengan jalankan:
```
named-checkconf
```
Lalu lakukan restart BIND9:
```
pkill named 2>/dev/null; sleep 1
service named start 2>/dev/null || named -u bind
sleep 3
ps aux | grep '[n]amed'
```
Pastikan kedua zona berhasil ditransfer dari utahime:
```
ls -l /var/lib/bind/
dig @127.0.0.1 www.jujutsu.K26.com +short
dig @127.0.0.1 -x 192.224.1.4 +short
dig @127.0.0.1 google.com +short
```

<img width="462" height="146" alt="Screenshot 2026-10-14 134541" src="https://github.com/user-attachments/assets/736b5fdc-567f-48e8-b9bf-5db413ee3299" />

**Uji CNAME, PTR, dan akses internet pada client Itadori**

Pada client itadori, pastikan IP dan DNS sudah didapat dari DHCP:
```
pkill udhcpc 2>/dev/null
ip addr flush dev eth0
udhcpc -i eth0 -O search -n -q
cat /etc/resolv.conf
```
Pastikan resolv.conf berisi search K26.com, nameserver 192.224.1.2, dan nameserver 192.224.1.3.
Cek A record dan CNAME:
```
dig @192.224.1.2 jujutsu.K26.com A +noall +answer
dig @192.224.1.2 www.jujutsu.K26.com +noall +answer
dig @192.224.1.3 www.jujutsu.K26.com +noall +answer
```

Cek PTR (reverse DNS) gojo:
```
dig @192.224.1.2 -x 192.224.1.4 +noall +answer
dig @192.224.1.3 -x 192.224.1.4 +noall +answer
```

Cek forwarder dengan resolve domain internet:
```
dig @192.224.1.2 google.com +short
dig @192.224.1.3 google.com +short
```

Buktikan client bisa ping ke domain internet:
```
ping -c 3 google.com
```

<img width="764" height="416" alt="Screenshot 2026-10-14 135256" src="https://github.com/user-attachments/assets/e2467e35-88ef-4bc4-b260-eaae3d79c80a" />
