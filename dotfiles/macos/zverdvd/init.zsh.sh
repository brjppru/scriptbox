#!/bin/sh

# 2026.10.31 oh-my-zsh is gone from .zshrc since 2026.03.15: install starship and zoxide instead

if ! command -v zsh >/dev/null 2>&1; then
    echo "[init] ERROR: zsh not found; install via Homebrew first"
    exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "[init] ERROR: brew not found; run init.brew.sh first"
    exit 1
fi

# .zshrc uses starship for the prompt and zoxide for directory jumps
for pkg in starship zoxide; do
    if command -v "$pkg" >/dev/null 2>&1; then
        echo "[init] INFO: $pkg already installed"
    else
        echo "[init] INFO: install $pkg..."
        brew install "$pkg"
    fi
done

# Cache dir for compinit dump, same path as in .zshrc
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "[init] WARN: ~/.oh-my-zsh is not used by .zshrc anymore, remove it by hand if not needed"
fi
