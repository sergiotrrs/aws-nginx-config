#!/bin/bash

TABS="------------------------------------"

echo "$TABS"
echo "Let's set up your .jar"
echo "Make sure your API is cloned inside a certain *-api directory inside your home directory"
echo "$TABS"

# Attempt to automatically find the application directory
APP_DIRS=($(find "/home/ec2-user/" -type d -name "*-api" 2>/dev/null))

determine_build_tool_dir() {
	local dir=$1

	[[ -f "$dir/pom.xml" ]] && echo "maven:$dir" && return
	[[ -f "$dir/build.gradle" || -f "$dir/build.gradle.kts" ]] && echo "gradle:$dir" && return

	echo "none"
}

build_jar() {
	local tool_dir=($1)
	local tool=${tool_dir[0]}
	local dir=${tool_dir[1]}

	case $tool in
	maven)
		mvn -f "$dir/pom.xml" clean package -DskipTests
		;;
	gradle)
		sudo chmod +x "$dir/gradlew"
		"$dir/gradlew" -p "$dir" build -x test
		;;
	*)
		echo "Unsupported build tool: $tool"
		return 1
		;;
	esac

	local status=$?
	echo "$tool build exited with status $status"
	[[ $status -ne 0 ]] && return 1
}

cp_jar() {
	local tool_dir=($1)
	local tool=${tool_dir[0]}
	local dir=${tool_dir[1]}
	local jar_path=""

	case $tool in
	maven)
		jar_path=$(find "$dir/target" -name "*.jar" ! -name "*-plain.jar" ! -name "*-javadoc.jar" ! -name "*-sources.jar" -print -quit)
		;;
	gradle)
		jar_path=$(find "$dir/build/libs" -name "*.jar" ! -name "*-plain.jar" -print -quit)
		;;
	esac

	[[ -z "$jar_path" ]] && echo "No .jar file was found" && exit 1
	cp "$jar_path" /home/ec2-user/app/app.jar && echo "Jar copied succesfully into ~/app/"
}

[[ -z "${APP_DIRS[0]}" ]] &&
	echo "App directory not found. Please enter the path to your application's directory:" &&
	read APP_DIR && APP_DIRS=($APP_DIR)

for dir in "${APP_DIRS}"; do
	tool_dir=($(determine_build_tool_dir "$dir"))
	[[ "${tool_dir}" == "none" ]] &&
		echo "No supported build tool was found in $dir" && continue

	build_jar "${tool_dir[*]}" && echo "Build succesfull for ${tool_dir[*]}" ||
		{
			echo "Build failed for ${tool_dir[*]}"
			exit 1
		}
	cp_jar "${tool_dir[*]}"
done
