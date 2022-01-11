#!/bin/bash

stow -R -v zshrc bin tmux nvim karabiner iterm2 alacritty -t ~
cp -r iterm2colors/*.itermcolors "${HOME}/.config/iterm2"

# defaults write com.googlecode.iterm2 DisableWindowSizeSnap -integer 1
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/.config/iterm2_plist/"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.knollsoft.Rectangle gapSize 20
