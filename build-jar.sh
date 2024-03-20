#!/bin/bash

TABS="------------------------------------"

echo "$TABS"
echo "Let's set up your .jar"
echo "Make sure your API is cloned inside a certain *-api directory inside your home directory"
echo "$TABS"

# Attempt to automatically find the application directory
APP_DIRS=($(find ~/ -type d -name "*-api" 2>/dev/null))

determine_build_tool_dir() {
	local dir=$1

	[[ -f "$dir/pom.xml" ]] && echo "maven:$dir" && return
	[[ -f "$dir/build.gradle" || -f "$dir/build.gradle.kts" ]] &&
		echo "gradle:$dir" && return
	echo "none"
}

build_jar() {
	local tool_dir=($1)
	local tool=${tool_dir[0]}
	local dir=${tool_dir[1]}

	case $tool in
	maven)
		mvn -f "$dir/pom.xml" clean package -DskipTests >/dev/null 2>&1
		;;
	gradle)
		sudo chmod +x "$dir/gradlew"
		"$dir/gradlew" -p "$dir" build -x test >/dev/null 2>&1
		;;
	*)
		return 1
		;;
	esac
}

cp_jar() {
	local tool_dir=($1)
	local tool=${tool_dir[0]}
	local dir=${tool_dir[1]}
	local jar_path=""

	case $tool in
	maven)
		jar_path=$(find "$dir/target" -name "*.jar" ! -name "*-plain.jar" ! -name "*-javadoc.jar" ! -name "*-sources.jar" ! -name "*-javadoc.jar" -print -quit)
		;;
	gradle)
		jar_path=$(find "$dir/build/libs" -name "*.jar" ! -name "*-plain.jar" -print -quit)
		;;
	esac

	[[ -z "$jar_path" ]] &&
		{
			echo "No .jar file was found"
			exit 1
		}
	cp "$jar_path" ~/app/app.jar &&
		echo "Jar copied succesfully into ~/app/"
}

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
