# Add a non-root user to run the application
RUN useradd -m laraveluser

# Set the working directory
WORKDIR /var/www

# Switch to the non-root user
USER laraveluser

# Install PHP dependencies with Composer
RUN composer install --no-dev --optimize-autoloader
