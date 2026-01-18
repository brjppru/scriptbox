#!/bin/sh

if ! command -v brew >/dev/null 2>&1; then
    echo "[init] INFO: install homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >> "$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "[init] INFO: homebrew already installed"
fi

brew update
brew upgrade
