# ⏰ Laravel Scheduler (Cron) Setup

Dokumentasi ini menjelaskan bagaimana Laravel scheduler (`php artisan schedule:run`) dijalankan di container `support_app`, `bengkel_gim`, dan `hris_tsp` — dan apa yang harus dicek kalau cron berhenti jalan.

## Latar Belakang

Sebelumnya, image `dockerfile/php-apache2.dockerfile` (dipakai oleh `support_app` dan `bengkel_gim`) serta `dockerfile/hris_tsp.dockerfile` (dipakai oleh `hris_tsp`) **tidak pernah** menjalankan cron daemon. `ENTRYPOINT` cuma `apachectl -DFOREGROUND`, jadi jadwal yang didefinisikan di `app/Console/Kernel.php` (mis. `command:DowntimeProdRun` di support_app) tidak pernah benar-benar dieksekusi meskipun kodenya sudah benar.

Fix: tambahkan `cron` daemon + crontab entry ke image, dan ganti entrypoint jadi script yang menjalankan cron + apache berbarengan.

## Bagaimana Cara Kerjanya

File yang terlibat (lokasi: root repo `multi-php/`):

| File | Fungsi |
|---|---|
| `dockerfile/php-apache2.dockerfile` | Install paket `cron`, copy crontab & start script, ganti `ENTRYPOINT` |
| `dockerfile/cron/laravel-scheduler` | Crontab entry, jalan tiap menit |
| `dockerfile/start.sh` | Entrypoint baru: start `cron`, lalu `exec apachectl -DFOREGROUND` |

Isi `dockerfile/cron/laravel-scheduler`:
```
* * * * * cd /var/www/html && php artisan schedule:run >> /var/log/laravel-scheduler.log 2>&1
```

Isi `dockerfile/start.sh`:
```sh
#!/bin/sh
set -e
cron
exec /usr/sbin/apachectl -DFOREGROUND
```

Pattern ini generik untuk ketiga app — path `/var/www/html` selalu sama, hanya isi mount (source code) yang beda per container. Jadi crontab entry ini otomatis berlaku untuk `support_app`, `bengkel_gim`, dan `hris_tsp` tanpa perlu diubah per app.

**Penting:** tiap app tetap punya `->hourly()` / `->everyMinute()` / dll masing-masing di `app/Console/Kernel.php` miliknya sendiri — crontab di atas cuma pemicu (`schedule:run` tiap menit), keputusan "kapan command sebenarnya jalan" tetap diatur di kode Laravel per app.

## Rollout / Rebuild

Setelah ubah file di atas, wajib **rebuild image**, restart saja tidak cukup:

```bash
cd /Volumes/CaseSensitiveDisk/multi-php
docker compose build support_app bengkel_gim hris_tsp
docker compose up -d support_app bengkel_gim hris_tsp
```

Cara cek image beneran rebuild (bukan re-use image lama):
```bash
docker inspect support_app --format 'Entrypoint: {{.Config.Entrypoint}} | Created: {{.Created}}'
```
Harus keluar `Entrypoint: [/start.sh]` dengan `Created` timestamp terbaru (bukan minggu/bulan lalu).

## Verifikasi Cron Jalan

### 1. Proses cron ada di dalam container
```bash
docker exec support_app ps aux
```
Harus ada baris `cron` (bukan cuma `apache2`).

### 2. Crontab & start script kepasang
```bash
docker exec support_app sh -c 'ls -la /start.sh /etc/cron.d/laravel-scheduler; crontab -l'
```

### 3. Log scheduler beneran ke-trigger
```bash
docker exec support_app tail -f /var/log/laravel-scheduler.log
```
Tunggu sampai menit berjalan — akan muncul baris `INFO No scheduled commands are ready to run.` (kalau belum ada command yang due) atau `Running [...] DONE` (kalau ada command yang jalan).

### 4. Test manual command langsung (tanpa nunggu jadwal)
```bash
docker exec -w /var/www/html support_app php artisan command:DowntimeProdRun
```

## Troubleshooting

| Gejala | Kemungkinan Penyebab |
|---|---|
| `ps aux` gak ada proses `cron` | Image belum di-rebuild (masih pakai image lama) — jalankan ulang `docker compose build` |
| `/start.sh` / `/etc/cron.d/laravel-scheduler` gak ada di container | Sama seperti di atas — build gagal/belum jalan, atau `docker compose up -d` cuma restart tanpa flag rebuild |
| Log scheduler kosong terus | Cek apakah `cron` proses hidup (`ps aux`), cek crontab (`crontab -l`), cek isi `/var/log/laravel-scheduler.log` permission-nya |
| Command jadwalan tidak pernah "due" | Cek frekuensi di `app/Console/Kernel.php` (`->hourly()` cuma due di menit ke-00, `->everyMinute()` tiap menit, dst) |
| Salah satu app (`bengkel_gim`/`hris_tsp`) belum kena fix | Setiap container harus di-rebuild memakai Dockerfile yang dikonfigurasi di Compose — jalankan `docker compose build <nama_service>` untuk app yang belum |

## Catatan untuk Setup Baru / Environment Lain

Kalau bikin environment baru dari image ini (staging, environment baru, dsb.), fix ini **otomatis ikut** karena sudah masuk ke `dockerfile/php-apache2.dockerfile` — tidak perlu langkah manual tambahan di luar `docker compose build`.
