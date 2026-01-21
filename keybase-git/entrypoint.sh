#!/bin/bash
# Keybase Git Entrypoint Script
# This script configures Git and executes the command

set -e

# Function to configure Git from environment variables
configure_git() {
    if [ -n "$GIT_USER_NAME" ]; then
        git config --global user.name "$GIT_USER_NAME"
        echo "✓ Git user.name set to: $GIT_USER_NAME"
    fi

    if [ -n "$GIT_USER_EMAIL" ]; then
        git config --global user.email "$GIT_USER_EMAIL"
        echo "✓ Git user.email set to: $GIT_USER_EMAIL"
    fi
}

# Configure Git from environment variables
configure_git

# Execute the command passed to the container
exec "$@"

