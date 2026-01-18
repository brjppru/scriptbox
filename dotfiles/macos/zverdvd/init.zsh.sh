#!/bin/sh

if ! command -v zsh >/dev/null 2>&1; then
    echo "[init] ERROR: zsh not found; install via Homebrew first"
    exit 1
fi

if ! command -v git >/dev/null 2>&1; then
    echo "[init] ERROR: git not found; install git first"
    exit 1
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "[init] INFO: install oh-my-zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[init] INFO: oh-my-zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_plugin() {
    name="$1"
    url="$2"
    dest="$3"

    if [ -d "$dest" ]; then
        echo "[init] INFO: $name already installed"
        return 0
    fi

    echo "[init] INFO: install $name..."
    git clone "$url" "$dest"
}

clone_plugin \
    "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

clone_plugin \
    "autoupdate" \
    "https://github.com/TamCore/autoupdate-oh-my-zsh-plugins" \
    "$ZSH_CUSTOM/plugins/autoupdate"

clone_plugin \
    "fast-syntax-highlighting" \
    "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" \
    "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
