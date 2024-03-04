#!/bin/bash

TABS="------------------------------------"

echo "$TABS"
echo "Let's set up your .jar"
echo "Make sure your API is cloned inside a certain *-api directory inside your home directory"
echo "$TABS"

# Attempt to automatically find the application directory
APP_DIRS=($(find ~/ -type d -name "*-api" 2>/dev/null))

# Check if the APP_DIR variable is empty and prompt for manual input if necessary
[ -z "${APP_DIRS[0]}" ] &&
	echo "App directory not found." &&
	echo "Please enter the path to your application's directory:" &&
	read APP_DIR ||
	APP_DIR="${APP_DIRS[0]}" # Default to the first found dir_

echo "$TABS"
echo "Building the .jar ..."

sudo chmod +x "$APP_DIR/gradlew" &&
	"$APP_DIR/gradlew" build -x test &&
	echo "Build sucessful." ||
	{
		echo "Build failed. Exiting."
		exit1
	}

echo "$TABS"
echo "Now copying the .jar into ~/app/"

# Find the first .jar file
JAR_FILE=$(find "$APP_DIR/build/libs" -name "*.jar" ! -name "*-plain.jar" -print -quit)

[ -f "$JAR_FILE"] &&
	cp "$JAR_FILE" ~/app/app.jar ||
	{
		echo "No .jar file was found inside build/libs. \nExiting."
		exit 1
	}
