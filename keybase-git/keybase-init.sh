#!/bin/bash
# Keybase initialization script
# This script handles Keybase authentication within the container

set -e

# Check if Keybase is installed
if ! command -v keybase &> /dev/null; then
    echo "Warning: Keybase is not installed. Skipping Keybase initialization."
    exit 0
fi

# Check if required environment variables are set
if [ -z "$KEYBASE_USERNAME" ] || [ -z "$KEYBASE_PAPERKEY" ]; then
    echo "Warning: KEYBASE_USERNAME or KEYBASE_PAPERKEY not set. Skipping Keybase initialization."
    exit 0
fi

echo "Initializing Keybase for user: $KEYBASE_USERNAME"

# Start Keybase service in background
keybase service &

# Wait a moment for service to start
sleep 2

# Login with paper key using environment variables
keybase login "$KEYBASE_USERNAME"

# Verify login
if keybase whoami &> /dev/null; then
    echo "Keybase login successful for user: $KEYBASE_USERNAME"
else
    echo "Error: Keybase login failed"
    exit 1
fi

echo "Keybase initialization completed successfully"

