#!/bin/bash

THEMES_DIR="$HOME/.config/themes/"
CURRENT_THEME_LINK="$HOME/.config/theme"

THEMES=($(find "$THEMES_DIR" -mindepth 1 -maxdepth 1 -type d | sort))
TOTAL=${#THEMES[@]}

# Get current theme from symlink
if [[ -L "$CURRENT_THEME_LINK" ]]; then
  CURRENT_THEME=$(readlink "$CURRENT_THEME_LINK")
else
  # Default to first theme if no symlink exists
  CURRENT_THEME=${THEMES[0]}
fi

# Find current theme index
INDEX=0
for i in "${!THEMES[@]}"; do
  if [[ "${THEMES[$i]}" == "$CURRENT_THEME" ]]; then
    INDEX=$i
    break
  fi
done

# Get next theme (wrap around)
NEXT_INDEX=$(((INDEX + 1) % TOTAL))
NEW_THEME=${THEMES[$NEXT_INDEX]}
NEW_THEME_NAME=$(basename "$NEW_THEME")

# Set current theme
ln -nsf "$NEW_THEME" "$HOME/.config/theme"

# Touch ghostty config to pickup the changed theme
# Note: No Programmic way to reload Ghostty config you must restart to see theme
touch "$HOME/.config/ghostty/config"

# Restart for new theme
pkill waybar
makoctl reload
hyprctl reload
hyprctl hyprpaper reload , "$HOME/.config/theme/wallpaper.jpg"
hyprctl dispatch exec waybar

# Notify of the new theme
notify-send "Theme changed to $NEW_THEME_NAME" -t 5000
