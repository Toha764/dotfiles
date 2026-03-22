### Oh My Zsh & Plugins 

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh

eval "$(zoxide init zsh)"

# vim-mode & editor settings
set -o vi
bindkey -M viins '^P' up-line-or-beginning-search
bindkey -M viins '^N' down-line-or-beginning-search
export EDITOR="nvim"
export VISUAL="nvim"

# ~Nyaan 
echo -e "\e[35m
                    /\_/\  
                   ( o.o ) 
                    > ^ <  
\e[0m"
### Aliases ###

alias src='source ~/.zshrc'
alias rc='nvim $HOME/.zshrc'
alias gc='cd ~/.config/ && yazi'

# quality of life
alias ip='curl -s ipinfo.io'
alias cat="bat"
alias nv="nvim"
alias yz="yazi"
alias c="clear"
alias attach="tmux attach 2>/dev/null || tmux new-session -s main"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"

# fuzzy-spam
alias fman='man $(man -k . | fzf | awk "{print \$1}" | sed "s/(.*//")'
alias lo='source ~/scripts/fzf-oldfiles.sh'

# git 
alias gadd="git add ."
alias gs="git status -s"
alias gcommit='git commit -m'
alias gp='git push origin main'
alias glog='git log --oneline --graph --all'
alias gcreate='gh repo create --private --source=. --remote=origin'
