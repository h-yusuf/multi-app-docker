# =========================================
# PHP 8.2 + Apache (untuk bind-mount runtime)
# =========================================
FROM php:8.2-apache

LABEL maintainer="Your Name <you@example.com>"

# -----------------------------
# Set timezone (optional)
# -----------------------------
ENV TZ=Asia/Jakarta

# -----------------------------
# Install dependencies & PHP extensions
# -----------------------------
RUN apt-get update && apt-get install -y \
    git unzip zip curl vim \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libonig-dev libxml2-dev \
    libssl-dev libicu-dev libpq-dev \
 && docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-install gd mysqli pdo_mysql zip opcache mbstring xml intl bcmath \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# -----------------------------
# Enable Apache rewrite (penting untuk Laravel)
# -----------------------------
RUN a2enmod rewrite

# -----------------------------
# Default Apache document root ke /var/www/html/public
# -----------------------------
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# -----------------------------
# Install Composer (versi stabil)
# -----------------------------
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.7.7 --install-dir=/usr/local/bin --filename=composer \
 && composer --version

# -----------------------------
# Permission dasar
# -----------------------------
RUN chown -R www-data:www-data /var/www/html

# -----------------------------
# Expose Apache port
# -----------------------------
EXPOSE 80

# -----------------------------
# Start Apache
# -----------------------------
CMD ["apache2-foreground"]