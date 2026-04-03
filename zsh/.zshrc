### Oh My Zsh & Plugins 
ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh
source <(fzf --zsh)
eval "$(zoxide init zsh)"
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

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
alias ip='curl -s ipinfo.io'

# quality of life
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"
alias c="clear"
alias cat="bat"
alias nv="nvim"
alias yz="yazi"
alias tx="tmux attach 2>/dev/null || tmux new-session -s main"

# fuzzy-everything
alias lo='source ~/scripts/fzf-oldfiles.sh'                                    # fuzzy last opened
alias fv="nvim \$(fzf --preview 'bat --color=always {}')"                      # fuzzy nvim
alias fcd="cd \$(fd --type d | fzf --preview 'eza --tree --color=always {}')"  # fuzzy change dir
alias fkill="ps aux | fzf | awk '{print \$2}' | xargs kill"                    # fuzzy kill process
alias fman='man $(man -k . | fzf | awk "{print \$1}" | sed "s/(.*//")'         # fuzzy man

# git 
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias gp='git push origin main'
alias glog='git log --oneline --graph --all'
alias gcreate='gh repo create --private --source=. --remote=origin'



