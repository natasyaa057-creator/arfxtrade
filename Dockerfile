FROM php:8.2-apache

# Install ekstensi PHP yang dibutuhkan aplikasi
RUN apt-get update && apt-get install -y --no-install-recommends \
    libzip-dev \
    unzip \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && rm -rf /var/lib/apt/lists/*

# Aktifkan mod_rewrite untuk dukungan .htaccess
RUN a2enmod rewrite

# Izinkan .htaccess di document root
RUN sed -ri 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Copy source code ke web root
COPY . /var/www/html/

# Script startup untuk menyesuaikan Apache dengan PORT dari Render
COPY docker/apache-start.sh /usr/local/bin/apache-start.sh
RUN chmod +x /usr/local/bin/apache-start.sh

WORKDIR /var/www/html

EXPOSE 10000

CMD ["/usr/local/bin/apache-start.sh"]

