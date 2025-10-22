# 🔧 Troubleshooting Guide

Panduan lengkap untuk mengatasi masalah umum pada Multi-PHP Development Environment.

## 🚨 Common Issues

### 1. Port 80 Already in Use

**Error Message:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
```

**Solutions:**

```bash
# Option 1: Find and stop conflicting service
sudo lsof -i :80
sudo systemctl stop apache2
sudo systemctl stop nginx

# Option 2: Use different port
# Edit docker-compose.yml
ports:
  - "8080:80"  # Change to port 8080

# Then access via http://app1.local:8080
```

### 2. Permission Denied Errors

**Error Message:**
```
Permission denied: /var/www/html/index.php
```

**Solutions:**

```bash
# Fix ownership
sudo chown -R $USER:$USER app/
sudo chown -R $USER:$USER config/
sudo chown -R $USER:$USER log/

# Fix permissions
chmod -R 755 app/
chmod -R 644 config/
chmod -R 755 log/

# For SELinux systems
sudo setsebool -P httpd_can_network_connect 1
```

### 3. Container Won't Start

**Error Message:**
```
Container exited with code 1
```

**Debugging Steps:**

```bash
# Check logs
docker-compose logs <service_name>

# Check container status
docker-compose ps

# Try starting manually
docker-compose up <service_name>

# Rebuild if needed
docker-compose build --no-cache <service_name>
docker-compose up -d <service_name>
```

### 4. DNS Resolution Issues

**Error Message:**
```
This site can't be reached
```

**Solutions:**

```bash
# Check hosts file
cat /etc/hosts

# Add missing entries
echo "127.0.0.1 app1.local" | sudo tee -a /etc/hosts

# Flush DNS cache (Mac)
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Flush DNS cache (Linux)
sudo systemctl restart systemd-resolved

# Flush DNS cache (Windows)
ipconfig /flushdns
```

### 5. PHP Extensions Missing

**Error Message:**
```
Call to undefined function imagick_*()
```

**Solutions:**

```bash
# Check installed extensions
docker exec app1 php -m

# Rebuild container with extensions
# Edit dockerfile/php-apache2.dockerfile if needed

# Or install manually in running container
docker exec -it app1 bash
apt-get update
apt-get install php8.0-imagick
service apache2 restart
```

### 6. Database Connection Issues

**Error Message:**
```
SQLSTATE[HY000] [2002] Connection refused
```

**Solutions:**

```bash
# Check if database container is running
docker ps | grep mysql

# Add database service to docker-compose.yml
mysql:
  image: mysql:8.0
  environment:
    MYSQL_ROOT_PASSWORD: root
    MYSQL_DATABASE: testdb
  ports:
    - "3306:3306"
  networks:
    - route

# Use container name as host in PHP
$host = 'mysql'; // not localhost
```

### 7. File Upload Issues

**Error Message:**
```
File size exceeds upload_max_filesize
```

**Solutions:**

```bash
# Edit php.ini files
nano config/php8.0/php.ini

# Increase limits
upload_max_filesize = 100M
post_max_size = 100M
memory_limit = 256M
max_execution_time = 300

# Restart container
docker-compose restart app2
```

### 8. Apache/Nginx Configuration Errors

**Error Message:**
```
AH00526: Syntax error on line X
```

**Solutions:**

```bash
# Test Apache config
docker exec app1 apache2ctl configtest

# Test Nginx config
docker exec route nginx -t

# Check config files
nano config/apache2/app1.conf
nano config/route/app1.conf

# Restart services
docker-compose restart app1 route
```

## 🔍 Debugging Commands

### Container Inspection

```bash
# List all containers
docker ps -a

# Inspect container
docker inspect app1

# Check container resources
docker stats

# View container processes
docker exec app1 ps aux
```

### Log Analysis

```bash
# View all logs
docker-compose logs

# Follow specific service logs
docker-compose logs -f app1

# View last 100 lines
docker-compose logs --tail=100 app1

# View logs with timestamps
docker-compose logs -t app1
```

### Network Debugging

```bash
# List networks
docker network ls

# Inspect network
docker network inspect route

# Test connectivity between containers
docker exec app1 ping app2
docker exec app1 ping route

# Check port binding
docker port route
```

### File System Issues

```bash
# Check disk space
df -h

# Check volume mounts
docker exec app1 mount | grep /var/www/html

# List files in container
docker exec app1 ls -la /var/www/html

# Compare with host
ls -la app/app1/
```

## 🚀 Performance Issues

### Slow Response Times

```bash
# Check container resources
docker stats

# Increase memory limits in docker-compose.yml
deploy:
  resources:
    limits:
      memory: 1G
      cpus: '1.0'

# Enable OPcache in php.ini
opcache.enable=1
opcache.memory_consumption=256
opcache.max_accelerated_files=20000
```

### High Memory Usage

```bash
# Check PHP memory usage
docker exec app1 php -i | grep memory_limit

# Optimize php.ini
memory_limit = 256M
max_execution_time = 60
max_input_vars = 3000

# Use PHP-FPM instead of mod_php (advanced)
```

## 🛠️ Advanced Debugging

### Enable Debug Mode

Add to your PHP application:

```php
<?php
// Enable all errors
error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);
ini_set('error_log', '/var/log/apache2/php_errors.log');

// Debug info
echo "<h3>Debug Info</h3>";
echo "PHP Version: " . PHP_VERSION . "<br>";
echo "Server: " . $_SERVER['SERVER_NAME'] . "<br>";
echo "Document Root: " . $_SERVER['DOCUMENT_ROOT'] . "<br>";
echo "Script Name: " . $_SERVER['SCRIPT_NAME'] . "<br>";
?>
```

### Container Health Checks

Add to docker-compose.yml:

```yaml
app1:
  # ... other config
  healthcheck:
    test: ["CMD", "curl", "-f", "http://localhost"]
    interval: 30s
    timeout: 10s
    retries: 3
    start_period: 40s
```

### Monitoring Scripts

Create monitoring script:

```bash
#!/bin/bash
# monitor.sh

echo "=== Container Status ==="
docker-compose ps

echo -e "\n=== Resource Usage ==="
docker stats --no-stream

echo -e "\n=== Disk Usage ==="
df -h

echo -e "\n=== Network Connectivity ==="
for app in app1 app2 app3 app4 app5 app6; do
    echo -n "$app: "
    curl -s -o /dev/null -w "%{http_code}" http://$app.local || echo "FAILED"
done
```

## 📞 Getting Help

### Before Asking for Help

1. **Check logs**: `docker-compose logs`
2. **Verify configuration**: Check all config files
3. **Test basic connectivity**: `ping`, `curl`
4. **Check resources**: `docker stats`
5. **Review recent changes**: What was changed last?

### Information to Include

When reporting issues, include:

```bash
# System info
uname -a
docker --version
docker-compose --version

# Container status
docker-compose ps

# Logs (last 50 lines)
docker-compose logs --tail=50

# Configuration files
cat docker-compose.yml
cat config/apache2/app1.conf
```

### Common Solutions Summary

| Issue | Quick Fix |
|-------|-----------|
| Port in use | `sudo lsof -i :80` then stop service |
| Permission denied | `sudo chown -R $USER:$USER .` |
| Container won't start | `docker-compose logs <service>` |
| DNS not working | Check `/etc/hosts` file |
| PHP errors | Enable error reporting |
| Slow performance | Check `docker stats` |
| Config errors | Test with `apache2ctl configtest` |

---

**Need more help?** Check the main [README.md](README.md) or create an issue in the repository.
