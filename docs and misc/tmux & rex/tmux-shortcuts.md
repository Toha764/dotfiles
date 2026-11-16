# Tmux Custom Shortcuts

This document lists the custom keybindings defined in `.tmux.conf` that differ from the default Tmux behavior.

*(Note: The prefix key remains the default `Ctrl + b`)*

## General

| Shortcut | Action | Note |
| :--- | :--- | :--- |
| `Prefix` + `r` | Reload Tmux configuration | |
| `Prefix` + `_` | Toggle (hide/show) status bar | |
| `Prefix` + `d` | Open Dotfiles Menu (Popup) | |

## Windows & Panes

| Shortcut | Action | Replaces Default |
| :--- | :--- | :--- |
| `Prefix` + `\|` | Split window horizontally | `%` |
| `Prefix` + `-` | Split window vertically | `"` |
| `Prefix` + `h` | Select left pane | `Left Arrow` |
| `Prefix` + `j` | Select down pane | `Down Arrow` |
| `Prefix` + `k` | Select up pane | `Up Arrow` |
| `Prefix` + `l` | Select right pane | `Right Arrow` |
| `Prefix` + `m` | Toggle maximize pane | `z` |
| `Prefix` + `x` | Kill pane (without confirm) | `x` (with confirm) |
| `Prefix` + `n` | Create new session (prompts for name) | `Next window` |

## Copy Mode (Vi style)

| Shortcut | Action | Replaces Default |
| :--- | :--- | :--- |
| `Prefix` + `v` | Enter copy mode | `[` |
| `v` | Begin selection | `Space` |
| `y` | Copy selection | `Enter` |

*(Note: Dragging the mouse to select text no longer automatically copies and exits copy mode).*

## Popups & Integrations

| Shortcut | Action |
| :--- | :--- |
| `Prefix` + `Ctrl`+`t` | Open a floating shell popup |
| `Prefix` + `Ctrl`+`g` | Open Lazygit in a popup |
| `Prefix` + `Ctrl`+`h` | Open htop in a popup |
| `Prefix` + `o` | Open `sesh` (session manager) with `fzf-tmux` |
