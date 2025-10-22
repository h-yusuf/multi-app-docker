# 📖 Contoh Penggunaan Multi-PHP

Panduan lengkap dengan contoh-contoh nyata penggunaan Multi-PHP Development Environment.

## 🚀 Contoh Setup Aplikasi Laravel

### 1. Buat folder project didalam folder app

```bash
mkdir app/laravel-app
```

### 2. Jalankan command build route

```bash
bash route.sh
```

### 3. Jalankan command build container

```bash
bash build.sh -n laravel-app -v 8.2 -d /public
```

**Parameter yang digunakan:**
- `-n` = laravel-app (nama aplikasi)
- `-v` = 8.2 (PHP version untuk Laravel 10)
- `-d` = /public (Laravel menggunakan public directory)

### 4. Edit file host, dan tambah domain app.local

```bash
sudo nano /etc/hosts
```

Tambahkan:
```
127.0.0.1 localhost laravel-app.local
```

### 5. Restart container route

```bash
docker restart route
```

### 6. Start container app

```bash
docker start laravel-app
```

### 7. Install Laravel

```bash
# Enter container
docker exec -it laravel-app bash

# Install Laravel via Composer
cd /var/www/html
composer create-project laravel/laravel . --prefer-dist

# Set permissions
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Exit container
exit
```

### 8. Test Aplikasi

Akses: http://laravel-app.local

---

## 🎯 Contoh Setup Aplikasi Legacy PHP 5.6

### 1. Buat folder project didalam folder app

```bash
mkdir app/legacy-system
```

### 2. Jalankan command build route

```bash
bash route.sh
```

### 3. Jalankan command build container

```bash
bash build.sh -n legacy-system -v 5.6
```

**Parameter yang digunakan:**
- `-n` = legacy-system
- `-v` = 5.6 (untuk aplikasi lama)
- `-d` = tidak digunakan (root directory default)

### 4. Edit file host, dan tambah domain app.local

```bash
sudo nano /etc/hosts
```

Tambahkan:
```
127.0.0.1 localhost legacy-system.local
```

### 5. Restart container route

```bash
docker restart route
```

### 6. Start container app

```bash
docker start legacy-system
```

### 7. Deploy Aplikasi Legacy

```bash
# Copy aplikasi existing ke folder
cp -r /path/to/old-app/* app/legacy-system/

# Atau clone dari repository
cd app/legacy-system
git clone https://github.com/company/legacy-app.git .
```

### 8. Test Aplikasi

Akses: http://legacy-system.local

---

## 🔧 Contoh Setup Multiple API Services

### Setup API v1 (PHP 7.4)

```bash
# 1. Buat folder
mkdir app/api-v1

# 2. Build route (hanya sekali)
bash route.sh

# 3. Build container
bash build.sh -n api-v1 -v 7.4

# 4. Edit hosts
echo "127.0.0.1 api-v1.local" | sudo tee -a /etc/hosts

# 5. Restart route
docker restart route

# 6. Start container
docker start api-v1
```

### Setup API v2 (PHP 8.3)

```bash
# 1. Buat folder
mkdir app/api-v2

# 2. Build container (route sudah ada)
bash build.sh -n api-v2 -v 8.3

# 3. Edit hosts
echo "127.0.0.1 api-v2.local" | sudo tee -a /etc/hosts

# 4. Restart route
docker restart route

# 5. Start container
docker start api-v2
```

### Test Multiple APIs

```bash
# Test API v1
curl http://api-v1.local/health

# Test API v2
curl http://api-v2.local/health
```

---

## 🌐 Contoh Setup WordPress

### 1. Buat folder project didalam folder app

```bash
mkdir app/wordpress-site
```

### 2. Jalankan command build route

```bash
bash route.sh
```

### 3. Jalankan command build container

```bash
bash build.sh -n wordpress-site -v 8.1
```

### 4. Edit file host, dan tambah domain app.local

```bash
sudo nano /etc/hosts
```

Tambahkan:
```
127.0.0.1 localhost wordpress-site.local
```

### 5. Restart container route

```bash
docker restart route
```

### 6. Start container app

```bash
docker start wordpress-site
```

### 7. Install WordPress

```bash
# Download WordPress
cd app/wordpress-site
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz --strip-components=1
rm latest.tar.gz

# Set permissions
docker exec wordpress-site chown -R www-data:www-data /var/www/html
```

### 8. Setup Database (Optional)

Tambahkan MySQL service ke docker-compose.yml:

```yaml
mysql:
  image: mysql:8.0
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: wordpress
    MYSQL_USER: wp_user
    MYSQL_PASSWORD: wp_pass
  ports:
    - "3306:3306"
  networks:
    - route
```

### 9. Test WordPress

Akses: http://wordpress-site.local

---

## 🔄 Contoh Migration PHP Version

### Scenario: Upgrade dari PHP 7.4 ke PHP 8.2

#### 1. Setup Environment Testing

```bash
# Buat aplikasi test dengan PHP 8.2
mkdir app/myapp-php82
bash build.sh -n myapp-php82 -v 8.2

# Copy aplikasi existing
cp -r app/myapp/* app/myapp-php82/

# Edit hosts
echo "127.0.0.1 myapp-php82.local" | sudo tee -a /etc/hosts

# Restart dan start
docker restart route
docker start myapp-php82
```

#### 2. Test Compatibility

```bash
# Check PHP version
docker exec myapp-php82 php -v

# Test aplikasi
curl http://myapp-php82.local

# Check error logs
docker exec myapp-php82 tail -f /var/log/apache2/error.log
```

#### 3. Fix Compatibility Issues

```bash
# Enter container untuk debugging
docker exec -it myapp-php82 bash

# Install additional extensions jika diperlukan
apt-get update
apt-get install php8.2-gd php8.2-curl

# Restart Apache
service apache2 restart
```

---

## 📊 Monitoring dan Maintenance

### Check Status Semua Container

```bash
# View status
docker-compose ps

# Check resource usage
docker stats

# View logs semua container
docker-compose logs --tail=50
```

### Backup Aplikasi

```bash
# Backup aplikasi
tar -czf backup-myapp-$(date +%Y%m%d).tar.gz app/myapp/

# Backup database (jika ada)
docker exec mysql mysqldump -u root -p wordpress > backup-db-$(date +%Y%m%d).sql
```

### Update PHP Configuration

```bash
# Edit php.ini
nano config/php8.2/php.ini

# Restart container untuk apply changes
docker restart myapp
```

---

## 🚨 Troubleshooting Common Issues

### Container tidak bisa start

```bash
# Check logs
docker logs myapp

# Rebuild container
docker-compose build --no-cache myapp
docker-compose up -d myapp
```

### Domain tidak bisa diakses

```bash
# Check hosts file
cat /etc/hosts | grep myapp

# Check nginx config
docker exec route nginx -t

# Restart route container
docker restart route
```

### Permission issues

```bash
# Fix permissions
sudo chown -R $USER:$USER app/myapp/
chmod -R 755 app/myapp/

# Fix container permissions
docker exec myapp chown -R www-data:www-data /var/www/html
```

---

**Tip**: Selalu test aplikasi di environment yang berbeda sebelum deployment ke production!
