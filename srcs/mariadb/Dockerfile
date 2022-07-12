# syntax=docker/dockerfile:1
FROM debian:buster

# Install latest system updates
RUN apt update && apt upgrade -y

# Install required software
RUN apt install -y mariadb-server mariadb-client

# Set up mysql/mariadb and start in the foreground
COPY utils/setup.sh /tmp/setup.sh
CMD ["sh", "/tmp/setup.sh"]
