#!/bin/sh

# Add domain to configuration
echo "Replacing \"@@replace@@\" with \"${DOMAIN}\"..."
sed -i "s/@@replace@@/${DOMAIN}/" /etc/nginx/sites-enabled/default

echo "Replacement done. File:"
cat /etc/nginx/sites-enabled/default | grep "server_name"

echo "Disabling nginx daemon..."
if ! grep -Fxq "daemon off;" /etc/nginx/nginx.conf; then
	echo "daemon off;" >> /etc/nginx/nginx.conf
fi

echo "Generating SSL certificate..."
# https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-nginx-in-ubuntu-16-04
# C = Country Code
# ST = State/Province
# L = City (Locale)
# O = Organization Name
# OU = Organization Unit
# CN = Common Name (domain)
mkdir -p /etc/nginx/ssl
if [ ! -f "/etc/nginx/ssl/server.key" ] || [ ! -f "/etc/nginx/ssl/server.pem" ]; then
	openssl req -newkey rsa:2048 -x509 -days 365 -nodes \
		-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.pem \
		-subj "/C=NL/ST=Noord-Holland/L=Amsterdam/O=Codam/OU=Students/CN=${DOMAIN}"
fi

# Start nginx in the foreground
echo "Starting nginx now."
exec nginx
