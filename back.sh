#!/bin/bash

APP_DIR="/var/www/keban.xyz/bot/ContabilitateAPI"

REPO_URL="https://github.com/Dexpomar32/ContabilitateAPI.git"

MAIN_CLASS="com.task.backAPI.java"

is_running() {
    pgrep -f "$1" > /dev/null 2>&1
}

kill_process() {
    if is_running "$1"; then
        echo "Killing process: $1"
        pkill -f "$1"
    else
        echo "No process found for: $1"
    fi
}

SPRING_BOOT_PROCESS="backAPI"
kill_process "$SPRING_BOOT_PROCESS"
cd "$APP_DIR/.." || { echo "Parent directory not found"; exit 1; }

if [ -d "$APP_DIR" ]; then
    echo "Removing existing application directory..."
    rm -rf "$APP_DIR"
fi

echo "Cloning repository from GitHub..."
git clone "$REPO_URL" "$APP_DIR" || { echo "Git clone failed"; exit 1; }

cd "$APP_DIR" || { echo "Application directory not found"; exit 1; }

echo "Building the project..."
mvn clean install || { echo "Maven build failed"; exit 1; }

echo "Running the Spring Boot application..."
nohup mvn spring-boot:run -Dspring-boot.run.main-class="$MAIN_CLASS" > /dev/null 2>&1 &

echo "Deployment script executed successfully."
