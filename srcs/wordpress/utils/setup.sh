#!/bin/sh

echo "Domain: ${DOMAIN}"

echo "Downloading Wordpress..."
wp core download --allow-root

echo "Configuring Wordpress..."
wp core config --dbhost="$MDB_HOST" --dbname="$WP_DB_NAME" --dbuser="$WP_DB_USER" --dbpass="$WP_DB_PASS" --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root

echo "Setting permissions..."
chmod 644 wp-config.php

echo "Installing Wordpress..."
wp core install --url="$DOMAIN" --title="$WP_BLOG_NAME" --admin_name="$WP_ADM_NAME" --admin_password="$WP_ADM_PASS" --admin_email="$WP_ADM_EMAIL" --skip-email --allow-root

echo "Creating Wordpress user $WP_USER_NAME..."
wp user create "$WP_USR_NAME" "$WP_USR_MAIL" --user_pass="$WP_USR_PASS" --role=author --allow-root

# Enable file uploading
# cd wp-content
# mkdir uploads
# chgrp web uploads/
# chmod 775 uploads/

echo "Wordpress was successfully installed."

# Launch php-fpm in the foreground (-F)
php-fpm -F
