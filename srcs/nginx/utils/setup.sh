#!/bin/sh

# Add domain to configuration
echo "Replacing \"@@replace@@\" with \"${DOMAIN}\"..."
sed -i "s/@@replace@@/${DOMAIN}/" /etc/nginx/conf.d/default.conf

echo "Replacement done. File:"
cat /etc/nginx/conf.d/default.conf | grep "server_name"

echo "Disabling nginx daemon..."
echo "daemon off;" >> /etc/nginx/nginx.conf

# Start nginx in the foreground
echo "Starting nginx now."
exec nginx
