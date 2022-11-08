# syntax=docker/dockerfile:1
FROM debian:buster

# Install latest system updates
RUN apt update && apt upgrade -y

# Install required software
RUN apt install -y mariadb-server mariadb-client

# Initialize mariadb
RUN mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Enable remote login for mysql
RUN sed -i "/^skip-networking/c\# skip-networking" /etc/mysql/my.cnf
RUN sed -i '/^bind-address/c\bind-address = 0.0.0.0' /etc/mysql/mariadb.conf.d/50-server.cnf

# Set up mysql/mariadb and start in the foreground
COPY tools/setup.sh /tmp/setup.sh
CMD ["sh", "/tmp/setup.sh"]
