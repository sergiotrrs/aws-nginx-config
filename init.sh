#!/bin/bash

# Basic aws spring setup

echo "Installing necessary packages..."

REQUIRED_PACKAGES="mariadb105-server java-17 nginx"
## Pckgs
sudo dnf update
sudo dnf install $REQUIRED_PACKAGES

echo "Enabling mariadb server"

sudo sysemctl start mariadb &&
	sudo sysemctl enable mariadb &&
	sudo sysemctl status mariadb

echo "Enabling mysql secure installation..."

sudo mysql_secure_installation

echo "Creating necessary directories..."

sudo mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled ~./app
