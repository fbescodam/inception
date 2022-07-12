#!/bin/sh

# Start mariadb/mysql in the foreground (--console)
echo "Starting mysql..."
exec mysqld --user=mysql --console
