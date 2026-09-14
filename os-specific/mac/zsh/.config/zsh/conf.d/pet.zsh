# pet: snippet manager configuration
# https://github.com/knqyf263/pet

export FZF_CTRL_R_OPTS="
  --reverse
  --cycle
  --info=right
  --color header:italic
  --header 'alt+s (pet new)'
  --preview 'echo {}' --preview-window down:3:hidden:wrap
  --bind '?:toggle-preview'
  --bind 'alt-s:execute(pet new --tag {2..})+abort'"

# ^s — replace buffer with snippet
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER" </dev/tty)
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
bindkey '^s' pet-select

# ^p — append snippet to buffer with pipe
function pet-pipe() {
  local snippet
  snippet=$(pet search --query "" </dev/tty)
  [ -n "$snippet" ] && LBUFFER="${LBUFFER} | ${snippet}"
  zle redisplay
}
zle -N pet-pipe
bindkey '^p' pet-pipe

# ^n — jump cursor to next <parameter> placeholder
function _pet_move_cursor_to_next_parameter() {
  local match default match_len default_len parameter_offset
  match="$(echo "$BUFFER" | perl -nle 'print $& if /<.*?>/')"
  if [ -n "$match" ]; then
    setopt local_options no_glob_subst
    default="$(echo "$match" | perl -nle 'print $& if /(?<=).*(?=>)/')"
    match_len=${#match}
    default_len=${#default}
    parameter_offset=${#BUFFER%%$match*}
    CURSOR="$((parameter_offset + default_len))"
    BUFFER="${BUFFER[1,$parameter_offset]}${default}${BUFFER[$parameter_offset+$match_len+1,-1]}"
  fi
}
zle -N _pet_move_cursor_to_next_parameter
bindkey '^n' _pet_move_cursor_to_next_parameter

stty -ixon
