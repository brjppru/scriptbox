#!/bin/bash
set -euo pipefail

echo "Updating Homebrew..."
brew update
brew upgrade
brew cleanup

echo "Updating Brewfile..."
brew bundle dump --no-go

ts="$(date +%Y%m%d%H%M)"
host="$(hostname -s)"
new="brew//${ts}-${host}-brewfile"
mv -f "Brewfile" "$new"
