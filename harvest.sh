#!/usr/bin/env bash

# harvest.sh - Pulls selected dotfiles into your dotfiles repo
# Supports: tmux, zsh

set -e

# Set your destination directory (your dotfiles repo)
DOTFILES_REPO="$HOME/dev/dotfiles"

# List of files to harvest
declare -A DOTFILES_TO_HARVEST=(
  ["$HOME/.tmux.conf"]="$DOTFILES_REPO/tmux/.tmux.conf"
  ["$HOME/.zshrc"]="$DOTFILES_REPO/zsh/.zshrc"
)

# Optional: entire .zsh directory (like custom themes, functions)
ZSH_CUSTOM_DIR="$HOME/.zsh"
ZSH_CUSTOM_DEST="$DOTFILES_REPO/zsh/.zsh"

# Optional: entire .oh-my-zsh directory
OMZSH_CUSTOM_DIR="$HOME/.oh-my-zsh"
OMZSH_CUSTOM_DEST="$DOTFILES_REPO/zsh/.oh-my-zsh"

# Make sure destination folders exist
mkdir -p "$DOTFILES_REPO/tmux"
mkdir -p "$DOTFILES_REPO/zsh"

echo "Harvesting dotfiles..."

# Copy individual files
for src in "${!DOTFILES_TO_HARVEST[@]}"; do
  dest="${DOTFILES_TO_HARVEST[$src]}"
  if [ -f "$src" ]; then
    echo "Copying $src → $dest"
    cp "$src" "$dest"
  else
    echo "Warning: $src not found. Skipping."
  fi
done

# Copy entire .zsh directory if it exists
if [ -d "$ZSH_CUSTOM_DIR" ]; then
  echo "Copying $ZSH_CUSTOM_DIR → $ZSH_CUSTOM_DEST"
  rsync -av --delete "$ZSH_CUSTOM_DIR/" "$ZSH_CUSTOM_DEST/"
else
  echo "Warning: $ZSH_CUSTOM_DIR not found. Skipping directory sync."
fi

# Copy entire .oh-my-zsh directory if it exists
if [ -d "$OMZSH_CUSTOM_DIR" ]; then
  echo "Copying $OMZSH_CUSTOM_DIR → $OMZSH_CUSTOM_DEST"
  rsync -av --delete "$OMZSH_CUSTOM_DIR/" "$OMZSH_CUSTOM_DEST/"
else
  echo "Warning: $OMZSH_CUSTOM_DIR not found. Skipping directory sync."
fi

echo "Harvest complete."
