# fuzzy cd : directories only
fcd() {
  local dir
  dir=$(fd --type d . "${1:-.}" 2>/dev/null | fzf) && cd "$dir"
}
