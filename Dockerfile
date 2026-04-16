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

WORKDIR /var/www/html

EXPOSE 10000

CMD ["bash", "-lc", "PORT=${PORT:-10000}; DOCROOT=/var/www/html; if [ -f /var/www/html/arfxt/index.php ]; then DOCROOT=/var/www/html/arfxt; fi; sed -ri \"s#Listen 80#Listen ${PORT}#g\" /etc/apache2/ports.conf; sed -ri \"s#<VirtualHost \\*:80>#<VirtualHost *:${PORT}>#g\" /etc/apache2/sites-available/000-default.conf; sed -ri \"s#DocumentRoot /var/www/html#DocumentRoot ${DOCROOT}#g\" /etc/apache2/sites-available/000-default.conf; apache2-foreground"]

