#!/bin/sh

# Initialize mysql lib dir
mkdir -p /var/lib/mysql
rm -rf /var/lib/mysql/*

# Initialize mysqld socket dir
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialize mariadb
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Configure mariadb
echo "Setting up mariadb..."
cat << EOF > "/var/lib/mysql/init.sql"
-- Apply initial privileges
FLUSH PRIVILEGES;

-- Drop database used for testing
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';

-- Delete anonymous mysql user
DELETE FROM mysql.user WHERE User='';

-- Delete root user(s) where host is not local
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN('localhost', '127.0.0.1', '::1');

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASS';

-- Create wordpress database
CREATE DATABASE IF NOT EXISTS $WP_DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Create wordpress user, allow login on all hostnames (%)
CREATE USER '$WP_DB_USER'@'%' IDENTIFIED BY '$WP_DB_PASS';
GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$WP_DB_USER'@'%';

-- Enable logging
SET GLOBAL general_log = 'ON';
SET GLOBAL slow_query_log = 'ON';

-- Apply new privileges
FLUSH PRIVILEGES;
EOF
mysqld --user=mysql --bootstrap < "/var/lib/mysql/init.sql"
rm -f /var/lib/mysql/init.sql
echo "Mariadb set up."

# Enable remote login
sed -i "s/skip-networking/# skip-networking/" /etc/mysql/my.cnf
sed -i "s/.*bind-address\s*=.*/bind-address=0.0.0.0/" /etc/mysql/my.cnf

# Enable logs
echo "[mysqld_safe]" >> /etc/mysql/my.cnf
echo "log_error=/var/lib/mysql/error.log" >> /etc/mysql/my.cnf
echo "general_log_file=/var/lib/mysql/gen.log" >> /etc/mysql/my.cnf
echo "general_log=1g" >> /etc/mysql/my.cnf
echo "" >> /etc/mysql/my.cnf
echo "[mysqld]" >> /etc/mysql/my.cnf
echo "log_error=/var/lib/mysql/error.log" >> /etc/mysql/my.cnf
echo "general_log_file=/var/lib/mysql/gen.log" >> /etc/mysql/my.cnf
echo "general_log=1" >> /etc/mysql/my.cnf

# Start mariadb/mysql in the foreground (--console)
echo "Starting mysql..."
mysqld --user=mysql --console > /var/lib/mysql/fuck.log
