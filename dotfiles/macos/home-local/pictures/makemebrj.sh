#!/bin/bash
# Download GitHub avatar for user brjppru and convert to PNG

set -euo pipefail

# Check if current user is brjed
CURRENT_USER=$(id -un)
REQUIRED_USER="brjed"

if [ "${CURRENT_USER}" != "${REQUIRED_USER}" ]; then
    echo "Error: This script must be run by user ${REQUIRED_USER}, not ${CURRENT_USER}" >&2
    exit 1
fi

GITHUB_USER="brjppru"
AVATAR_URL="https://github.com/${GITHUB_USER}.png"
TEMP_FILE="/tmp/brjavatar.png"
PICTURES_DIR="${HOME}/Pictures"
AVATAR_FILE="${PICTURES_DIR}/brjavatar.png"

# Create Pictures directory if it doesn't exist
mkdir -p "${PICTURES_DIR}"

# Download avatar using curl
if command -v curl >/dev/null 2>&1; then
    curl -sSL -o "${TEMP_FILE}" "${AVATAR_URL}"
    echo "Avatar downloaded successfully to ${TEMP_FILE}"
elif command -v wget >/dev/null 2>&1; then
    wget -q -O "${TEMP_FILE}" "${AVATAR_URL}"
    echo "Avatar downloaded successfully to ${TEMP_FILE}"
else
    echo "Error: Neither curl nor wget is available" >&2
    exit 1
fi

# Copy to Pictures directory
cp "${TEMP_FILE}" "${AVATAR_FILE}"
echo "Avatar copied to ${AVATAR_FILE}"

# Convert avatar image - convert to PNG and ensure minimum 512x512
if command -v sips >/dev/null 2>&1; then
    sips -s format png -s formatOptions 100 -Z 512 "${AVATAR_FILE}" --out "${AVATAR_FILE}" >/dev/null 2>&1
    echo "Avatar converted and resized to ${AVATAR_FILE}"
else
    echo "Warning: sips not found, skipping conversion" >&2
fi

# Copy suslan.jpg to Pictures directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUSLAN_SOURCE="${SCRIPT_DIR}/suslan.jpg"
SUSLAN_FILE="${PICTURES_DIR}/suslan.jpg"

if [ -f "${SUSLAN_SOURCE}" ]; then
    cp "${SUSLAN_SOURCE}" "${SUSLAN_FILE}"
    echo "Copied suslan.jpg to ${SUSLAN_FILE}"
else
    echo "Warning: suslan.jpg not found at ${SUSLAN_SOURCE}" >&2
fi
