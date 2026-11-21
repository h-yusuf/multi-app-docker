FROM ubuntu:22.04

ARG php_version
ARG app_name

ENV php_version=${php_version:-5.6}
ENV app_name=${app_name}

RUN apt-get update

RUN apt-get install -y tzdata

RUN export DEBIAN_FRONTEND=noninteractive && ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

RUN apt-get install -y -f software-properties-common

RUN dpkg-reconfigure --frontend noninteractive tzdata

# Use the repository directly so builds do not depend on the Launchpad API.
COPY dockerfile/ondrej-php.gpg /usr/share/keyrings/ondrej-php.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/ondrej-php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu/ jammy main" > /etc/apt/sources.list.d/ondrej-php.list && apt-get update

RUN apt-get install -y \
    apt-transport-https curl wget nano git unzip apache2 cron php$php_version \
    php$php_version-imagick \
    php$php_version-curl \
    php$php_version-gd \
    php$php_version-mbstring \
    php$php_version-mysql \
    php$php_version-pgsql \
    php$php_version-bcmath \
    php$php_version-bz2 \
    php$php_version-zip \
    php$php_version-memcache \
    php$php_version-xml \
    php$php_version-dom \
    php$php_version-sqlite3

RUN if [ "$php_version" = "5.6" ] || [ "$php_version" = "7.0" ] || [ "$php_version" = "7.1" ] || [ "$php_version" = "7.2" ] || [ "$php_version" = "7.3" ] || [ "$php_version" = "7.4" ]; then apt-get install -y php$php_version-json ; fi

RUN apt-get purge -y software-properties-common

WORKDIR /tmp

RUN curl -s https://getcomposer.org/installer | php

RUN mv composer.phar /usr/local/bin/composer

RUN update-alternatives --set php /usr/bin/php$php_version

RUN a2enmod ssl && service apache2 start && a2enmod rewrite && service apache2 reload

COPY dockerfile/cron/laravel-scheduler /etc/cron.d/laravel-scheduler
RUN chmod 0644 /etc/cron.d/laravel-scheduler && crontab /etc/cron.d/laravel-scheduler

COPY dockerfile/start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

RUN rm -r /var/www/html && \
    rm /etc/php/$php_version/cli/php.ini && \
    rm -r /etc/apache2/sites-available && \
    rm -r /var/log/apache2

RUN apt-get autoremove -y

EXPOSE 80
