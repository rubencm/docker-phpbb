ARG PHP_VERSION
FROM php:${PHP_VERSION}-apache

ARG PHPBB_VERSION
ARG PHPBB_REVISION

# install required packages
RUN set -ex; \
  apt update && \
  apt install -y --no-install-recommends \
    libbz2-dev \
    libcurl3-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libldap2-dev \
    libpng-dev \
    libsqlite3-dev \
    libsqlite3-0 \
    libwebp-dev \
    libxml2-dev \
    libxpm-dev \
    libzip-dev \
    mariadb-client \
    postgresql-client && \
  docker-php-ext-configure \
    gd --with-freetype --with-jpeg --with-webp; exit 0 && \
  docker-php-ext-install  -j$(nproc) \
    bz2 \
    curl \
    ftp \
    gd \
    intl \
    ldap \
    libxml \
    json \
    mysqli \
    opcache \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    phar \
    mbstring \
    random \
    sockets \
    xml

# apache
RUN a2enmod rewrite
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# download phpbb
RUN curl -O https://download.phpbb.com/pub/release/${PHPBB_VERSION}/${PHPBB_VERSION}.${PHPBB_REVISION}/phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2 && \
    curl -O https://download.phpbb.com/pub/release/${PHPBB_VERSION}/${PHPBB_VERSION}.${PHPBB_REVISION}/phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2.sha256 && \
    sha256sum --check phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2.sha256 && \
    tar -xvf phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2 -C /var/www/html --strip-components=1 && \
    rm phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2 phpBB-${PHPBB_VERSION}.${PHPBB_REVISION}.tar.bz2.sha256 && \
#    chown -R www-data:www-data /var/www/html && \
#    chmod -R 777 /var/www/html
    true
