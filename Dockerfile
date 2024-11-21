# Use the official PHP image with necessary dependencies
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Create a non-root user and set up the working directory
RUN useradd -m laraveluser

# Set the working directory
WORKDIR /var/www

# Copy the application files to the container
COPY . /var/www

# Change ownership of the files to the non-root user
RUN chown -R laraveluser:laraveluser /var/www

# Switch to the non-root user
USER laraveluser

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies using Composer
RUN composer install --no-dev --optimize-autoloader

# Expose port for PHP-FPM
EXPOSE 9000

# Run PHP-FPM
CMD ["php-fpm"]
