#!/bin/bash

# Basic aws spring setup

echo "Installing necessary packages..."
TABS="------------------------------------"

REQUIRED_PACKAGES="mariadb105-server java-17 nginx maven"
## Pckgs
sudo dnf update
sudo dnf install $REQUIRED_PACKAGES

echo "Enabling mariadb server"

sudo systemctl start mariadb &&
	sudo systemctl enable mariadb &&
	sudo systemctl status mariadb

echo "$TABS"
echo "Enabling mysql secure installation..."
echo "$TABS"
echo "Change necessary information here"

sudo mysql_secure_installation

echo "$TABS"
echo "Creating necessary directories..."

sudo mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled ~/app/

echo "$TABS"
echo "You should now clone your Rest API repository and build the .jar file"
echo "You can also clone it and run the jar-build.sh script"
