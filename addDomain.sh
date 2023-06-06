#!/bin/bash

# Set the necessary variables
USERNAME="beater"
DOMAIN_NAME="cloud.cloudcrafters.co.za"

# Create a new user/domain
v-add-user $USERNAME $USERNAME_password
v-add-domain $USERNAME $DOMAIN_NAME

# Add necessary DNS records
v-add-dns-domain $USERNAME $DOMAIN_NAME
v-add-dns-record $USERNAME $DOMAIN_NAME www A 1.2.3.4

# Set up the web directory
WEB_DIR="/home/$USERNAME/web/$DOMAIN_NAME/public_html"
mkdir -p $WEB_DIR
chown $USERNAME:$USERNAME $WEB_DIR
chmod 755 $WEB_DIR

# Restart relevant services
systemctl restart nginx
systemctl restart apache2

echo "Domain $DOMAIN_NAME has been successfully added!"
