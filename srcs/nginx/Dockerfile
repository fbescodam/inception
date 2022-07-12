# syntax=docker/dockerfile:1
FROM debian:buster

# Install latest system updates
RUN apt update && apt upgrade -y

# Install required software
RUN apt install -y nginx openssl

# Copy configuration and set up domain name
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Set up and start nginx
WORKDIR /etc/nginx
COPY utils/setup.sh /tmp/setup.sh
CMD ["sh", "/tmp/setup.sh"]
