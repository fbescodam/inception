# syntax=docker/dockerfile:1
FROM debian:buster

# Install latest system updates
RUN apt update && apt upgrade -y

# Install required software
RUN apt install -y nginx openssl

# Copy configuration and set up domain name
COPY config/nginx.conf /etc/nginx/conf.d/default.conf

# Create SSL certificate
# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# C = Country Code
# ST = State/Province
# L = City (Locale)
# O = Organization Name
# OU = Organization Unit
# CN = Common Name (domain)
WORKDIR /etc/nginx/ssl
RUN openssl req -newkey rsa:2048 -x509 -days 365 -nodes -keyout server.key -out server.csr -subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/OU=Students/CN=${DOMAIN}"

# Set up and start nginx
WORKDIR /etc/nginx
COPY utils/setup.sh /tmp/setup.sh
CMD ["sh", "/tmp/setup.sh"]
