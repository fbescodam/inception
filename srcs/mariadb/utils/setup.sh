#!/bin/sh

# Initialize mariadb
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Configure mariadb
echo "Setting up mariadb..."
cat << EOF > "init.sql"
USE mysql;

-- Apply initial privileges
FLUSH PRIVILEGES;

-- Drop database used for testing
DROP DATABASE `test`;
DELETE FROM mysql.db WHERE Db='test';

-- Delete anonymous mysql user
DELETE FROM	mysql.user WHERE User='';

-- Delete root user(s) where host is not local
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN('localhost', '127.0.0.1', '::1');

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASS';

-- Create wordpress database
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME CHARACTER_SET utf8 COLLATE utf8_general_ci;

-- Create wordpress user, allow login on all hostnames (%)
CREATE USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%';

-- Apply new privileges
FLUSH PRIVILEGES;
EOF
mysqld ---user=mysql --bootstrap < "init.sql"
rm -rf init.sql
echo "Mariadb set up."

# Enable remote login
sed -i "s/skip-networking/# skip-networking/" /etc/mysql/my.cnf
sed -i "s/.*bind-address\s*=.*/bind-address=0.0.0.0/" /etc/mysql/my.cnf

# Start mariadb/mysql in the foreground (--console)
echo "Starting mysql..."
exec mysqld --user=mysql --console
