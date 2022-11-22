#!/bin/bash

stow -R -v zshrc bin tmux nvim karabiner iterm2 alacritty cheat -t ~
cp -r iterm2colors/*.itermcolors "${HOME}/.config/iterm2"

# defaults write com.googlecode.iterm2 DisableWindowSizeSnap -integer 1
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/.config/iterm2_plist/"
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.knollsoft.Rectangle gapSize 20

defaults write -g InitialKeyRepeat -int 15 # normal minimum is 15 (225 ms), can be 10
defaults write -g KeyRepeat -int 2 # normal minimum is 2 (30 ms), can be 1

# trying to help Rectangle to set up with right shortcuts
defaults write "Apple Global Domain" NSUserKeyEquivalents -dict-add "Hide Others" ""

