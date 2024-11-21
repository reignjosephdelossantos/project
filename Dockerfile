# Use an official PHP image with FPM and extensions
FROM php:8.1-fpm

# Install system dependencies and PHP extensions for Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

# Set working directory
WORKDIR /var/www

# Copy composer.json and composer.lock to install dependencies first for caching purposes
COPY composer.json composer.lock ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies with Composer
RUN composer install --no-dev --optimize-autoloader

# Copy the rest of the application code
COPY . .

# Set file permissions
RUN chown -R www-data:www-data /var/www && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 for the app to listen on
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
