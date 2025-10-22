# 🚀 Quick Start Guide

Panduan cepat untuk memulai menggunakan Multi-PHP Development Environment.

## ⚡ Setup dalam 5 Menit

### 1. Prerequisites Check

```bash
# Check Docker
docker --version
# Output: Docker version 20.10.x

# Check Docker Compose  
docker-compose --version
# Output: docker-compose version 2.x.x
```

### 2. Clone & Setup

```bash
# Clone repository
git clone <your-repo-url>
cd multi-php

# Make scripts executable
chmod +x build.sh route.sh
```

### 3. Start Environment

```bash
# Setup routing
./route.sh

# Start all services
docker-compose up -d

# Check status
docker-compose ps
```

### 4. Setup Local DNS

Tambahkan ke `/etc/hosts`:

```bash
echo "127.0.0.1 app1.local app2.local app3.local app4.local app5.local app6.local" | sudo tee -a /etc/hosts
```

### 5. Test Access

Buka browser dan akses:
- http://app1.local (PHP 5.6)
- http://app2.local (PHP 8.0)
- http://app3.local (PHP 7.4)
- http://app4.local (PHP 8.3)
- http://app5.local (PHP 8.1)
- http://app6.local (PHP 8.2)

## 🎯 Membuat Aplikasi Pertama

### Menggunakan Build Script

```bash
# Buat aplikasi dengan PHP 8.3
./build.sh -n myapp -v 8.3

# Tambahkan ke hosts
echo "127.0.0.1 myapp.local" | sudo tee -a /etc/hosts

# Buat file test
echo "<?php phpinfo(); ?>" > app/myapp/index.php

# Akses http://myapp.local
```

### Manual Setup

```bash
# 1. Buat direktori app
mkdir app/testapp

# 2. Buat file PHP
cat > app/testapp/index.php << 'EOF'
<?php
echo "<h1>Hello from PHP " . PHP_VERSION . "</h1>";
echo "<p>Server: " . $_SERVER['SERVER_NAME'] . "</p>";
phpinfo();
?>
EOF

# 3. Copy config Apache
cp config/apache2/app1.conf config/apache2/testapp.conf

# 4. Buat config Nginx
cat > config/route/testapp.conf << 'EOF'
server {
    listen 80;
    server_name testapp.local;
    
    location / {
        proxy_pass http://testapp:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# 5. Tambahkan ke hosts
echo "127.0.0.1 testapp.local" | sudo tee -a /etc/hosts

# 6. Build dan run container
docker build -t testapp:latest --build-arg php_version=8.2 --build-arg app_name=testapp -f ./dockerfile/php-apache2.dockerfile .

docker run -dit \
    -v "$PWD"/app/testapp:/var/www/html:Z \
    -v "$PWD"/config/php8.2/php.ini:/etc/php/8.2/cli/php.ini:Z \
    -v "$PWD"/config/apache2/testapp.conf:/etc/apache2/sites-available/000-default.conf:Z \
    --restart=always \
    --network=route \
    --name=testapp \
    testapp:latest

# 7. Restart nginx
docker restart route

# 8. Test: http://testapp.local
```

## 📋 Common Commands

```bash
# View all containers
docker-compose ps

# View logs
docker-compose logs -f app1

# Restart service
docker-compose restart app1

# Stop all
docker-compose down

# Rebuild service
docker-compose build --no-cache app1
docker-compose up -d app1

# Enter container
docker exec -it app1 bash

# Check PHP version in container
docker exec app1 php -v
```

## 🔧 Quick Fixes

### Container won't start
```bash
docker-compose logs <service_name>
docker-compose build --no-cache <service_name>
```

### Port 80 in use
```bash
sudo lsof -i :80
# Stop conflicting service or change port in docker-compose.yml
```

### Permission issues
```bash
sudo chown -R $USER:$USER app/
chmod -R 755 app/
```

### DNS not working
```bash
# Check hosts file
cat /etc/hosts

# Flush DNS (Mac)
sudo dscacheutil -flushcache

# Flush DNS (Linux)  
sudo systemctl restart systemd-resolved
```

## 🎉 You're Ready!

Environment Multi-PHP sudah siap digunakan. Untuk dokumentasi lengkap, lihat [README.md](README.md).
