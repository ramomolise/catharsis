#!/bin/bash

# API endpoint to create a new domain and install WordPress
# Usage: ./create_wordpress_domain.sh <domain_name> <username> <password>

DOMAIN="$1"
USERNAME="$2"
PASSWORD="$3"

# Validate input parameters
if [ -z "$DOMAIN" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
    echo "Usage: ./create_wordpress_domain.sh <domain_name> <username> <password>"
    exit 1
fi

# Generate a random password for the database
DB_PASSWORD=$(openssl rand -base64 12)

# Create a new domain in Hestia CP
v-add-domain $USERNAME $DOMAIN

# Install WordPress using wp-cli
wp core download --path="/home/$USERNAME/web/$DOMAIN/public_html"
wp config create --path="/home/$USERNAME/web/$DOMAIN/public_html" --dbname="${USERNAME}_${DOMAIN}" --dbuser="$USERNAME" --dbpass="$DB_PASSWORD" --extra-php <<PHP
define('WP_DEBUG', false);
PHP

# Generate a secure admin password
ADMIN_PASSWORD=$(openssl rand -base64 12)

# Install WordPress with the provided admin credentials
wp core install --path="/home/$USERNAME/web/$DOMAIN/public_html" --url="https://$DOMAIN" --title="My WordPress Site" --admin_user="admin" --admin_password="$ADMIN_PASSWORD" --admin_email="admin@$DOMAIN"

# Output the database details and admin credentials
echo "Database: ${USERNAME}_${DOMAIN}"
echo "Database User: $USERNAME"
echo "Database Password: $DB_PASSWORD"
echo "Admin Username: admin"
echo "Admin Password: $ADMIN_PASSWORD"
