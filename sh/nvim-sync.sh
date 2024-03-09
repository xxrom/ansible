#!/bin/bash

# Define the source nvim config directory and the target directory
SOURCE_DIR="$HOME/.config/nvim"
TARGET_DIR="$HOME/ansible/public_html"
ARCHIVE_NAME="nvim-config.tar.gz"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Compress the nvim configuration directory
echo "Compressing the nvim configuration directory..."
tar -czvf "$TARGET_DIR/$ARCHIVE_NAME" -C "$SOURCE_DIR" .

# Move to the target directory
cd "$TARGET_DIR"

# Start the HTTP server
echo "Starting HTTP server on port 8000..."
python3 -m http.server 8000
