#!/bin/bash

TABS="------------------------------------"

echo "$TABS"
echo "Let's set up your .jar"
echo "Make sure your API is cloned inside a certain *-api directory inside your home directory"
echo "$TABS"

# Attempt to automatically find the application directory
APP_DIR=$(find ~/ -type d -name "*-api" 2>/dev/null)

# Check if the APP_DIR variable is empty and prompt for manual input if necessary
[ -z "$APP_DIR" ] &&
	echo "App directory not found." &&
	echo "Please enter the path to your application's directory:" &&
	read APP_DIR

echo "$TABS"
echo "Building the .jar ..."

sudo chmod 700 "$APP_DIR/gradlew"

"$APP_DIR/gradlew" build -x test

echo "$TABS"
echo "Now copying the .jar to ~/app/"

cp "$APP_DIR/build/libs/*.jar" ~/app/app.jar
