# About

This repo contains [scripts](./scripts/scripts/), [tools](./cli-tools.md), wallpapers, personal configuration files for mac, linux, and (no not you windows) created over the years.

### Preview

<p align="center">
  <img src="./preview/forest_example.png" width="800"><br>
  <em>Forest Wallpaper - macOS</em>
</p>


# Setup

Personal config files, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure
Divided into two parts. i) os-agnostic ii) os-specific
```
dotfiles/
├── os-specific/
│   ├── mac/
│   │   ├── zsh/
│   │   │   └── .zshrc
│   │   └── ...
│   └── linux/
│       ├── zsh/
│       │   └── .zshrc
│       └── ...
└── os-agnostic/
    ├── tmux/
    │   └── .tmux.conf
    ├── ghostty/
    │   └── ...
    └── yazi/
        └── ...
```

## Requirements
- Git
- Gnu Stow

```bash
# macOS
brew install stow

# Ubuntu / Debian
sudo apt install stow

# Arch
sudo pacman -S stow
```

## Getting Started

Make sure you're in Home directory. Otherwise change the commands accordingly.

### 1. Clone the Repo
```bash
git clone https://github.com/Toha764/dotfiles ~/dotfiles
cd ~/dotfiles
```
### 2. Apply configs

Use `./apply.sh mac` or  `./apply.sh linux` script
or apply one by one manually

```bash
stow -d <source directory> -t ~ <package>
```

- `-d` is where Stow looks for packages (defaults to the current directory)
- `-t` is where Stow creates the symlinks (your home directory)

**Apply everything for your OS at once:**

```bash
# macOS
cd ~/dotfiles/os-specific/mac && stow -t ~ */

# Linux
cd ~/dotfiles/os-specific/linux && stow -t ~ */
```

**Or pick and choose:**

```bash
# Just zsh on mac
stow -d ~/dotfiles/os-specific/mac -t ~ zsh

# Just zsh on linux
stow -d ~/dotfiles/os-specific/linux -t ~ zsh
```

*Apply shared packages (OS agnostic stuff):*

```bash
stow -d ~/dotfiles/os-agnostic -t ~ tmux
stow -d ~/dotfiles/os-agnostic -t ~ ghostty
stow -d ~/dotfiles/os-agnostic -t ~ yazi

# Or all of them at once
cd ~/dotfiles/os-agnostic && stow -t ~ */
```

*Apply scripts:*

```bash
chmod +x ~/dotfiles/scripts/.scripts/*
stow --dir=scripts --target=~ .scripts
```

---

## Useful commands

```bash
# Reapply a package (useful after adding new files to it)
stow -R -d ~/dotfiles/os-agnostic -t ~ tmux

# Remove a package's symlinks
stow -D -d ~/dotfiles/os-agnostic -t ~ tmux

# Dry run — see what Stow *would* do without actually doing it
stow -n -d ~/dotfiles/os-agnostic -t ~ tmux

# Verbose dry run (see every symlink it plans to create)
stow -nv -d ~/dotfiles/os-agnostic -t ~ tmux
```

---
# macOs Animations Disable

[Turn off all animations on mac](https://apple.stackexchange.com/questions/14001/how-to-turn-off-all-animations-on-os-x/142734?__cf_chl_tk=fnQZN1rhsYRvriQK2leX2Ocef2zKgg1zRVxDF_4pXhY-1786512309-1.0.1.1-G3rBItXqs0toHZXn_TvsmDLby8Dcn4u6_0A2YAja3po#142734)
```text
defaults write -g NSScrollViewRubberbanding -int 0
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g NSScrollAnimationEnabled -bool false
defaults write -g NSWindowResizeTime -float 0.001
defaults write -g QLPanelAnimationDuration -float 0
defaults write -g NSScrollViewRubberbanding -bool false
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false
defaults write -g NSToolbarFullScreenAnimationDuration -float 0
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0
defaults write com.apple.dock springboard-page-duration -float 0
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write NSGlobalDomain NSWindowResizeTime .001
defaults write com.apple.dock expose-animation-duration -int 0; killall Dock
defaults write com.apple.dock expose-animation-duration -float 0.1; killall Dock
```
