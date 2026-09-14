---
title: CLI Tools
tags: [cli, tools, reference]
---

# CLI Tools

> Favorites: bat, fzf, zoxide, tldr, yazi, pet
> Mac Specific: mole, mackup, unp

## Core Replacements

| Tool      | Replaces | What it does                                 |
| --------- | -------- | -------------------------------------------- |
| `eza`     | `ls`     | Directory listing with icons, git, tree view |
| `bat`     | `cat`    | File viewer with syntax highlighting         |
| `ripgrep` | `grep`   | Extremely fast recursive search              |
| `fd`      | `find`   | Simple, fast file finder                     |
| `dust`    | `du`     | Intuitive disk usage visualizer              |
| `procs`   | `ps`     | Modern process viewer                        |
| `btop`    | `top`    | Rich system and process monitor              |
| `zoxide`  | `cd`     | Smarter cd (`z <dir>`)                       |


---

## Shell & Navigation

| Tool      | What it does                                        |
| --------- | --------------------------------------------------- |
| `fzf`     | General-purpose fuzzy finder — ctrl+r, ctrl+t       |
| `yazi`    | Terminal file manager with fzf + zoxide integration |
| `tldr`    | Simplified, community-driven man pages              |
| `thefuck` | Suggests the correct command after a mistake        |
| `ttyd`    | Shell via Browser                                   |
| `grex`    | Regex creator from provided samples                 |

---

## Development

| Tool         | What it does                                      |
| ------------ | ------------------------------------------------- |
| `nvim`       | Extensible modal text editor                      |
| `lazygit`    | Terminal UI for git operations                    |
| `lazydocker` | Terminal UI for docker containers and images      |
| `direnv`     | Auto-loads env variables per directory (`.envrc`) |
| `stow`       | Manage dotfiles with symlinks                     |
| `asciinema`  | Record and share terminal sessions                |
| `fabric`     | AI-powered CLI for common LLM workflows           |

---

## File & Data

| Tool       | What it does                                |
| ---------- | ------------------------------------------- |
| `jq`       | JSON processor (`jq '.field'`)              |
| `unp`      | Universal archive extractor                 |
| `shred`    | Securely delete files (overwrite before rm) |
| `rsync`    | Fast, incremental file sync and backup      |
| `wormhole` | Send files securely between machines        |
| `croc`     | Also sends files but better                 |
| `column`   | Format text into aligned columns            |
| `faker`    | Generates fake data                         |


---

## Network & Security

| Tool        | What it does                                    |
| ----------- | ----------------------------------------------- |
| `termshark` | Terminal UI for Wireshark/tshark packet capture |

---

## Nix Ecosystem

| Tool         | What it does                                  |
| ------------ | --------------------------------------------- |
| `comma`      | Run software without installing (`, <cmd>`)   |
| `nix-tree`   | Browse Nix derivation dependency graphs       |
| `nix-index`  | Find which package owns a file (`nix-locate`) |
| `nvd`        | Diff package versions between Nix generations |
| `nix-direnv` | Faster Nix environment loading for direnv     |

---

## Productivity

| Tool          | What it does                                                   |
| ------------- | -------------------------------------------------------------- |
| `taskwarrior` | Powerful CLI task manager (todo list) with filters and reports |
