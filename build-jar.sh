#!/bin/bash

TABS="------------------------------------"

echo $TABS
echo "Let's setup you .jar"
echo "Make sure your api is cloned inside a certain **-api directory inside home"
echo $TABS

# Attempt to automatically find the application directory
APP_DIR=$(find / -type d -name "uniqueIdentifierDirectoryName" 2>/dev/null)

[-z "$APP_DIR"] &&
	echo "App directory not found" &&
	echo "Please enter the path to your application's directory" &&
	read APP_DIR
