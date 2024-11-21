# Use an official PHP image as the base image
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Set the working directory inside the container
WORKDIR /var/www

# Copy the composer.lock and composer.json first, for faster builds
COPY composer.json composer.lock ./

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Copy the rest of your project files into the container
COPY . .

# Set the appropriate file permissions
RUN chown -R www-data:www-data /var/www && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Expose port 9000 and start the PHP-FPM server
EXPOSE 9000

# Start the PHP-FPM server (this will run your app)
CMD ["php-fpm"]
