#!/usr/bin/env bash

# deploy.sh - Deploy selected dotfiles onto the machine
# Supports: tmux, zsh

set -e

# Set your source directory (your dotfiles repo)
DOTFILES_REPO="$HOME/dev/dotfiles"

# List of files to deploy
declare -A DOTFILES_TO_DEPLOY=(
  ["$DOTFILES_REPO/tmux/.tmux.conf"]="$HOME/.tmux.conf"
  ["$DOTFILES_REPO/zsh/.zshrc"]="$HOME/.zshrc"
)

# Optional: entire .zsh directory
ZSH_CUSTOM_SRC="$DOTFILES_REPO/zsh/.zsh"
ZSH_CUSTOM_DEST="$HOME/.zsh"

# Optional: entire .oh-my-zsh directory
OMZSH_CUSTOM_SRC="$DOTFILES_REPO/zsh/.oh-my-zsh"
OMZSH_CUSTOM_DEST="$HOME/.oh-my-zsh"

TMUX_CUSTOM_SRC="$DOTFILES_REPO/tmux/config"
TMUX_CUSTOM_DEST="$HOME/.config/tmux/"

echo "Deploying dotfiles..."

# Copy individual files
for src in "${!DOTFILES_TO_DEPLOY[@]}"; do
  dest="${DOTFILES_TO_DEPLOY[$src]}"
  if [ -f "$src" ]; then
    echo "Copying $src → $dest"
    cp "$src" "$dest"
  else
    echo "Warning: $src not found in repo. Skipping."
  fi
done

# Copy entire .zsh directory if it exists
if [ -d "$ZSH_CUSTOM_SRC" ]; then
  echo "Copying $ZSH_CUSTOM_SRC → $ZSH_CUSTOM_DEST"
  rsync -av --delete "$ZSH_CUSTOM_SRC/" "$ZSH_CUSTOM_DEST/"
else
  echo "Warning: $ZSH_CUSTOM_SRC not found. Skipping directory sync."
fi

echo "Deployment complete."

# Copy entire .oh-my-zsh directory if it exists
if [ -d "$OMZSH_CUSTOM_SRC" ]; then
  echo "Copying $OMZSH_CUSTOM_SRC → $OMZSH_CUSTOM_DEST"
  rsync -av --delete "$OMZSH_CUSTOM_SRC/" "$OMZSH_CUSTOM_DEST/"
else
  echo "Warning: $OMZSH_CUSTOM_SRC not found. Skipping directory sync."
fi

# Copy entire tmux config directory if it exists
if [ -d "$TMUX_CUSTOM_SRC" ]; then
  echo "Copying $TMUX_CUSTOM_SRC → $TMUX_CUSTOM_DEST"
  rsync -av --delete "$TMUX_CUSTOM_SRC/" "$TMUX_CUSTOM_DEST/"
else
  echo "Warning: $TMUX_CUSTOM_SRC not found. Skipping directory sync."
fi

echo "Deployment complete."
