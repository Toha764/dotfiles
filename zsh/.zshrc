### Oh My Zsh & Plugins 
ZSH_THEME="robbyrussell"
plugins=(git)
source $HOME/.oh-my-zsh/oh-my-zsh.sh
eval "$(zoxide init zsh)"
eval $(thefuck --alias fuck)

### Paths ###
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"

# ~Nyaan
echo -e "\e[35m
                    /\_/\  
                   ( o.o ) 
                    > ^ <  
\e[0m"

### Default editor ###
export EDITOR="nvim"
export VISUAL="nvim"

### General ###
alias ip='curl -s ipinfo.io'
alias src='source ~/.zshrc'
alias rc='nvim $HOME/.zshrc'
alias gc='cd ~/.config/ && yazi' #dotfiles 
alias gn='cd ~/300\ Resources/00\ Books/000\ Markdown_Notes && yazi'

### Aliases ###
alias cat="bat"
alias nv="nvim"
alias yz="yazi"

# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export GEMINI_API_KEY="$(cat ~/.secrets/gemini_key)"

# Nyan CLI
NYAN_HOME="$HOME/100 Projects/Py Projects/Nyan Bot"
nyan() {
  "$NYAN_HOME/venv/bin/python" "$NYAN_HOME/cli.py" "$@"
}

### notesgrep
notes() {
  local dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Notes & Books/00 Books/000 Markdown_Notes"

  ll result
  result=$(rg --line-number --no-heading --color=always --follow "" "$dir" -g "*.md" \
    | fzf --ansi \
          --delimiter ':' \
          --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
          --preview-window=right:60%)

  [ -z "$result" ] && return

  local file line
  file=$(echo "$result" | cut -d: -f1)
  line=$(echo "$result" | cut -d: -f2)

  nvim +"$line" "$file"
}
