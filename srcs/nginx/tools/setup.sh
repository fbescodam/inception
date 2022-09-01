#!/bin/sh

# Add domain to configuration
echo "Replacing \"@@replace@@\" with \"${DOMAIN}\"..."
sed -i "s/@@replace@@/${DOMAIN}/" /etc/nginx/conf.d/default.conf

echo "Replacement done. File:"
cat /etc/nginx/conf.d/default.conf | grep "server_name"

echo "Disabling nginx daemon..."
echo "daemon off;" >> /etc/nginx/nginx.conf

echo "Generating SSL certificate..."
# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# C = Country Code
# ST = State/Province
# L = City (Locale)
# O = Organization Name
# OU = Organization Unit
# CN = Common Name (domain)
mkdir -p /etc/nginx/ssl
openssl req -newkey rsa:2048 -x509 -days 365 -nodes \
	-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.pem \
	-subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/OU=Students/CN=${DOMAIN}"

# Start nginx in the foreground
echo "Starting nginx now."
exec nginx
