#!/bin/bash

# Script to list recent files and open nvim using fzf
# set to an alias nlof in .zshrc

list_oldfiles() {
    # Get the oldfiles list from Neovim
    local oldfiles=($(nvim -u NONE --headless +'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' +qa))
    # Filter invalid paths or files not found
    local valid_files=()
    for file in "${oldfiles[@]}"; do
        if [[ -f "$file" ]]; then
            valid_files+=("$file")
        fi
    done
    # Use fzf to select from valid files
local files=$(
  printf "%s\n" "${valid_files[@]}" |
  grep -v '\[.*' |
  fzf --multi \
      --height=80% \
      --layout=reverse \
      --border \
      --padding=1 \
      --margin=1 \
      --prompt=" Select files ❯ " \
      --pointer="▶" \
      --marker="✓" \
      --separator="─" \
      --color=bg+:#1e1e2e,bg:#181825,spinner:#f5e0dc,hl:#f38ba8 \
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
      --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
      --preview 'bat --style=numbers --color=always --line-range=:300 {} 2>/dev/null || echo "No preview available"' \
      --preview-window=right:60%:wrap \
      --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'
)

    # Open selected files in Neovim
    if [[ ${#files[@]} -gt 0 ]]; then
        # make neovim recognize path of the file opened
        local first_dir=$(dirname "${files[0]}")
        cd "$first_dir" || { echo "Failed to cd to $first_dir"; return 1; }
        nvim "${files[@]}"
    fi
}

# Call the function
list_oldfiles "$@"
