#!/bin/bash

# Install bluetooth controls
yay -S --noconfirm --needed blueman

# Turn on bluetooth by default
sudo systemctl enable --now bluetooth.service
