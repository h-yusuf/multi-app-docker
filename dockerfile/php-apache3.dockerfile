FROM php:5.6-apache

# Fix sources.list
RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list && \
    echo "deb http://archive.debian.org/debian-security stretch/updates main" >> /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid && \
    echo 'Acquire::AllowInsecureRepositories "true";' >> /etc/apt/apt.conf.d/99no-check-valid && \
    echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99no-check-valid

# Install dependencies
RUN apt-get update && apt-get install -y --allow-unauthenticated \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libzip-dev \
    libxml2-dev \
    unzip \
    nano \
    git \
    wget \
    curl \
    libmcrypt-dev \
    zlib1g-dev \
    libbz2-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install \
        mysqli \
        pdo \
        pdo_mysql \
        pgsql \
        gd \
        mbstring \
        bcmath \
        zip \
        curl \
        xml \
        bz2 \
    && apt-get clean
