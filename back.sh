#!/bin/bash

# Directory where the application should be deployed
APP_DIR="/var/www/keban.xyz/bot/ContabilitateAPI"  # Replace with the actual path to your deployment directory

# GitHub repository URL
REPO_URL="https://github.com/Dexpomar32/ContabilitateAPI.git"

# Name of the main class
MAIN_CLASS="com.task.backAPI.java"

# Function to check if a process is running
is_running() {
    pgrep -f "$1" > /dev/null 2>&1
}

# Function to kill a process if it's running
kill_process() {
    if is_running "$1"; then
        echo "Killing process: $1"
        pkill -f "$1"
    else
        echo "No process found for: $1"
    fi
}

# Check if the Spring Boot application is running and kill it
SPRING_BOOT_PROCESS="backAPI"
kill_process "$SPRING_BOOT_PROCESS"

# Navigate to the parent directory
cd "$APP_DIR/.." || { echo "Parent directory not found"; exit 1; }

# Remove the existing application directory if it exists
if [ -d "$APP_DIR" ]; then
    echo "Removing existing application directory..."
    rm -rf "$APP_DIR"
fi

# Clone the repository from GitHub
echo "Cloning repository from GitHub..."
git clone "$REPO_URL" "$APP_DIR" || { echo "Git clone failed"; exit 1; }

# Navigate to the application directory
cd "$APP_DIR" || { echo "Application directory not found"; exit 1; }

# Build the project using Maven
echo "Building the project..."
mvn clean install || { echo "Maven build failed"; exit 1; }

# Run the Spring Boot application
echo "Running the Spring Boot application..."
nohup mvn spring-boot:run -Dspring-boot.run.main-class="$MAIN_CLASS" > /dev/null 2>&1 &

echo "Deployment script executed successfully."
