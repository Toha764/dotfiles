### Oh My Zsh ###
ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

# ~Nyaan (IMPORTANT! shell session won't open without it!, obviously :3 )
echo -e "\e[35m
                    /\_/\  
                   ( o.o ) 
                    > ^ <  
\e[0m"

### Some vanilla zsh-config stolen from Kali Linux ###
# --- Navigation ---
setopt autocd              # cd into a directory just by typing its name
WORDCHARS='_- '           # treat _ and - as word separators (better movement/editing)

# --- Auto Completion ---
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

zstyle ':completion:*' menu select                          # interactive menu on TAB
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' auto-description 'specify: %d'       # better descriptions
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more%s

# --- History Improvements ---
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicates
setopt SHARE_HISTORY            # share history across sessions
setopt hist_ignore_space        # don't save commands starting with space
setopt hist_verify              # show expanded history before executing
setopt hist_expire_dups_first   # clean duplicates first when trimming

setopt CORRECT                  # auto-correct minor typos
setopt COMPLETE_IN_WORD         # allow completion inside words
setopt magicequalsubst          # expand paths in assignments (VAR=~/file)
setopt nonomatch                # don't error if glob doesn't match

# --- Keybindings (works w/ vi + emacs) ---
bindkey '^[[1;5C' forward-word   # Ctrl + →
bindkey '^[[1;5D' backward-word  # Ctrl + ←
bindkey '^U' backward-kill-line  # Ctrl + U delete line

NEWLINE_BEFORE_PROMPT=yes        # add spacing before each prompt

# --- Better man/help page colors ---
export LESS_TERMCAP_md=$'\E[1;36m'  # bold text
export LESS_TERMCAP_us=$'\E[1;32m'  # underline text

# ====================================================================
# From this point on, highly customized and requires dependencies
# git cli, fzf, zoxide, tmux, eza, bat, neovim
# ====================================================================

### FZF & Navigation Tools ###
source <(fzf --zsh)
eval "$(zoxide init zsh)"
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

### Editor & Mode ###
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"

### Smart Aliases ###
alias src='source ~/.zshrc'      # reload config
alias rc='nvim $HOME/.zshrc'    # edit config
alias ip='curl -s ipinfo.io'    # quick public IP info
alias lip="ifconfig | awk '/inet /{print $2}'"

# --- quick commands ---
alias c="clear"
alias nv="nvim"
alias yz="yazi"

# --- SUPER CUSTOM COMMANDS ---
alias cat="bat"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tk="taskwarrior-tui"
alias tx="tmux attach 2>/dev/null || tmux new-session -s main"
alias ask="~/.scripts/llm-agent-mac.sh"

### Fuzzy Obessesion ###
alias lo='source ~/.scripts/fzf-oldfiles.sh'                  # fuzzy recent files (script based)
alias fv="nvim \$(fzf --preview 'bat --color=always {}')"                      # fuzzy open file
alias fcd="cd \$(fd --type d | fzf --preview 'eza --tree --color=always {}')"  # fuzzy cd
alias fkill="ps aux | fzf | awk '{print \$2}' | xargs kill"                    # fuzzy kill process
alias fman='man $(man -k . | fzf | awk "{print \$1}" | sed "s/(.*//")'         # fuzzy man search

### Git Shortcuts ###
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias gp='git push origin main'
alias glog='git log --oneline --graph --all'
alias gcreate='gh repo create --private --source=. --remote=origin'

