#!/bin/bash

set -e

# Variables
REPO="your-github-username/your-repo-name" # Replace with your GitHub username and repository name
APP_NAME="myapp"                          # Replace with the name of your binary
INSTALL_DIR="/usr/local/bin"              # Directory to install the binary
LATEST_URL="https://api.github.com/repos/$REPO/releases/latest"

# Function to detect OS and Architecture
detect_platform() {
  OS=$(uname | tr '[:upper:]' '[:lower:]')
  ARCH=$(uname -m)

  case "$ARCH" in
    x86_64) ARCH="x86_64";;
    arm64) ARCH="aarch64";;
    *) echo "Unsupported architecture: $ARCH"; exit 1;;
  esac

  if [[ "$OS" == "darwin" ]]; then
    OS="apple-darwin"
  elif [[ "$OS" == "linux" ]]; then
    OS="unknown-linux-gnu"
  else
    echo "Unsupported OS: $OS"
    exit 1
  fi

  PLATFORM="${ARCH}-${OS}"
}

# Function to download and install the binary
install_binary() {
  echo "Fetching the latest release info..."
  DOWNLOAD_URL=$(curl -s $LATEST_URL | grep "browser_download_url" | grep "$PLATFORM" | cut -d '"' -f 4)

  if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "No binary available for your platform ($PLATFORM)."
    exit 1
  fi

  echo "Downloading $APP_NAME for $PLATFORM..."
  curl -L -o "$APP_NAME" "$DOWNLOAD_URL"

  echo "Installing $APP_NAME to $INSTALL_DIR..."
  chmod +x "$APP_NAME"
  sudo mv "$APP_NAME" "$INSTALL_DIR/"

  echo "$APP_NAME installed successfully!"
  echo "Run '$APP_NAME --help' to get started."
}

# Main Script
detect_platform
install_binary
