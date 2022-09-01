#!/bin/sh

until mysqladmin ping -hmariadb --silent; do
echo "Waiting for MariaDB to come online..."
	sleep 1
done

echo "Domain: ${DOMAIN}"

echo "Downloading Wordpress..."
wp core download --allow-root

echo "Configuring Wordpress..."
wp core config --dbhost="mariadb" --dbname="$WP_DB_NAME" --dbuser="$WP_DB_USER" --dbpass="$WP_DB_PASS" --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root

echo "Setting permissions..."
chmod 644 wp-config.php

echo "Installing Wordpress..."
wp core install --url="$DOMAIN" --title="$WP_BLOG_NAME" --admin_name="$WP_ADM_NAME" --admin_password="$WP_ADM_PASS" --admin_email="$WP_ADM_MAIL" --skip-email --allow-root

echo "Creating Wordpress user $WP_USER_NAME..."
wp user create "$WP_USR_NAME" "$WP_USR_MAIL" --user_pass="$WP_USR_PASS" --role=author --allow-root

# Enable file uploading
# cd wp-content
# mkdir uploads
# chgrp web uploads/
# chmod 775 uploads/

echo "Wordpress was successfully installed."
echo "Configuring php-fpm..."
sed -i '/^listen /c\listen = 9000' /etc/php/7.3/fpm/pool.d/www.conf
cat /etc/php/7.3/fpm/pool.d/www.conf | grep "listen ="

# Launch php-fpm in the foreground (-F)
echo "Launching php-fpm..."
mkdir -p /run/php
/usr/sbin/php-fpm7.3 -F
