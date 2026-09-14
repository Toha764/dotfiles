### oh my zsh ###
ZSH_THEME="robbyrussell"
ZSH_COMPDUMP="$HOME/.cache/zcompdump"   # keep compinit cache out of $HOME

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

# ~Nyaan (IMPORTANT! shell session won't open without it!, obviously :3 )
printf '\e[35m
                    /\_/\\
                   ( o.o )
                    > ^ <
\e[0m
'

### Some vanilla zsh-config stolen from Kali Linux ###
# --- navigation ---
setopt autocd              # cd into a directory just by typing its name
WORDCHARS='_- '           # treat _ and - as word separators (better movement/editing)

# --- auto completion ---
zstyle ':completion:*' menu select                          # interactive menu on TAB
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive matching
zstyle ':completion:*' auto-description 'specify: %d'       # better descriptions

# --- history improvements ---
setopt HIST_IGNORE_ALL_DUPS      # remove older duplicates
setopt SHARE_HISTORY            # share history across sessions
setopt hist_ignore_space        # don't save commands starting with space
setopt hist_verify              # show expanded history before executing
setopt hist_expire_dups_first   # clean duplicates first when trimming

# setopt CORRECT               # disabled — causes false corrections with git/custom cmds
setopt COMPLETE_IN_WORD         # allow completion inside words
setopt magicequalsubst          # expand paths in assignments (VAR=~/file)
setopt nonomatch                # don't error if glob doesn't match

# --- Keybindings (works w/ vi + emacs) ---
bindkey '^[[1;5C' forward-word   # Ctrl + →
bindkey '^[[1;5D' backward-word  # Ctrl + ←
bindkey '^U' backward-kill-line  # Ctrl + U delete line

NEWLINE_BEFORE_PROMPT=yes        # add spacing before each prompt

# ====================================================================
# From this point on, highly customized and requires dependencies
# git cli, fzf, zoxide, tmux, eza, bat, neovim, pet, fd, rg
# ====================================================================

### editor & mode ###
set -o vi
export EDITOR="nvim"
export VISUAL="nvim"

### FZF & navigation tools ###
source <(fzf --zsh)
eval "$(zoxide init zsh)"
export FZF_DEFAULT_OPTS='--height 50% --tmux bottom,50% --layout reverse --border top'

# --- SUPER CUSTOM COMMANDS ---
alias src='source ~/.zshrc'     # reload config
alias rc='nvim $HOME/.zshrc'    # edit config
alias c="clear"
alias nv="nvim"
alias yz="yazi"
alias cat="bat"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias tx="tmux attach 2>/dev/null || tmux new-session -s main"

### git shortcuts ###
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias gp='git push origin'
alias gl='git log --oneline --graph --all'
alias gcreate='gh repo create --private --source=. --remote=origin'

# exports
export CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
export ANTHROPIC_BASE_URL="http://localhost:20128"
export ANTHROPIC_AUTH_TOKEN="$(cat ~/.secrets/claude_key)"
export GOOGLE_CLIENT_ID="$(cat ~/.secrets/google/client_id)"
export GOOGLE_CLIENT_SECRET="$(cat ~/.secrets/google/client_secret)"
export PATH="$HOME/.scripts:$PATH"

### fuzzy obessesion ###
alias fnv="nvim \$(fzf --preview 'bat --color=always {}')"               

# sources
for f in ~/.config/zsh/conf.d/*.zsh(N); do source "$f"; done
