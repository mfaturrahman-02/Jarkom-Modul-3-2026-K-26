# PRAKTIKUM JARKOM MODUL 2 K 26 - 2026

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


2. Tengen, penjaga pusat distribusi di Data Center, harus mengambil alih pengalokasian alamat bagi wilayah yang membutuhkan konfigurasi dinamis. Konfigurasikan isc-dhcp-server pada [PREFIX IP].4.10. Deklarasikan Network 4 ([PREFIX IP].4.0/24) sebagai subnet lokal tanpa pool dinamis, lalu siapkan scope DHCP untuk Network 2 ([PREFIX IP].2.0/24) dan Network 3 ([PREFIX IP].3.0/24). Validasi konfigurasi dan pastikan service aktif tanpa error “No subnet declaration”.
