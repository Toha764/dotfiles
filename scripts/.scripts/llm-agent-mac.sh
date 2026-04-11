#!/bin/zsh
# =============================================================================
#  llm-agent-mac.sh — Natural language CLI agent for macOS
#  Powered by Ollama (gemma3:4b by default)
#
#  INSTALL
#  -------
#  1. Install Ollama:        https://ollama.com
#  2. Pull the model:        ollama pull gemma3:4b
#  3. Make executable:       chmod +x llm-agent-mac.sh
#  4. (Optional) alias it:   echo 'alias ask="~/llm-agent-mac.sh"' >> ~/.zshrc
#
#  USAGE
#  -----
#  One-shot:      ./llm-agent-mac.sh "find what's eating disk space"
#  With mode:     ./llm-agent-mac.sh --mode=net "show open ports"
#  Interactive:   ./llm-agent-mac.sh
#  Custom model:  MODEL=gemma3:12b ./llm-agent-mac.sh "show cpu temp"
#
#  MODES
#  -----
#  --mode=disk    Disk / filesystem commands
#  --mode=net     Network diagnostics
#  --mode=proc    Processes & services (launchctl)
#  --mode=pkg     Homebrew package management
#  (default)      General-purpose macOS commands
#
#  SAFETY
#  ------
#  Two-tier guard:
#    1. Model is instructed to prefix dangerous commands with [DESTRUCTIVE]
#       → requires typing "yes" in full to run
#    2. Regex blocklist catches patterns the model may have missed
#       → hard blocks, never executes
#
#  OUTPUT FORMAT (every response)
#  -----
#  <command>
#  -f: what this flag does
#  --flag: what this flag does
#  EFFECT: one plain-English sentence
# =============================================================================

# ── model ─────────────────────────────────────────────────────────────────────
# Override at call time:  MODEL=gemma3:12b ./llm-agent-mac.sh
MODEL="${MODEL:-bjoernb/gemma4-e4b-think:latest}"
# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[2m'
BLD='\033[1m'
RST='\033[0m'

# ── system detection ──────────────────────────────────────────────────────────
MACOS_VER=$(sw_vers -productVersion)
MACOS_NAME=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' \
  '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf' \
  2>/dev/null | awk -F 'macOS ' '{print $NF}' | awk '{print $1}' || echo "")
CHIP=$( [[ $(uname -m) == "arm64" ]] && echo "Apple Silicon" || echo "Intel" )
SHELL_NAME="zsh ${ZSH_VERSION}"
PKG_MGR=$(command -v brew &>/dev/null && echo "homebrew" || echo "none")
BREW_PREFIX=$(brew --prefix 2>/dev/null || echo "/usr/local")
RAM_GB=$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 ))

SYSINFO="macOS ${MACOS_VER} (${CHIP}), shell: zsh, pkg: ${PKG_MGR}, RAM: ${RAM_GB}GB"

# ── mode definitions ──────────────────────────────────────────────────────────
typeset -A MODES
MODES[disk]="Generate macOS disk and filesystem commands only.
  Prefer: du, df, diskutil list, ncdu, ls -lh, find -size.
  Never suggest rm, rmdir, or any deletion."

MODES[net]="Generate macOS network diagnostic commands only.
  Prefer: ifconfig, networksetup, netstat, lsof -i, nmap, ping, traceroute,
  dig, curl, Airport utility. Assume local network unless told otherwise.
  Avoid aggressive scans unless explicitly asked."

MODES[proc]="Generate macOS process and service commands only.
  Prefer: ps, top, htop, lsof, kill, launchctl, Activity Monitor CLI (powermetrics).
  For daemons use launchctl load/unload, not systemctl."

MODES[pkg]="Generate Homebrew commands only.
  Prefer: brew install, brew upgrade, brew list, brew info, brew search,
  brew cleanup, brew doctor. Never suggest pip or npm for this mode."

# ── parse args ────────────────────────────────────────────────────────────────
MODE="general"
ONESHOT_PROMPT=""

for arg in "$@"; do
  if [[ "$arg" == --mode=* ]]; then
    MODE="${arg#--mode=}"
  else
    ONESHOT_PROMPT="$arg"
  fi
done

MODE_CTX="${MODES[$MODE]:-Generate safe, minimal zsh commands for macOS. Prefer built-in macOS tools.}"

# ── safety: regex blocklist ───────────────────────────────────────────────────
# Catches dangerous patterns even if the model forgets [DESTRUCTIVE].
is_dangerous() {
  echo "$1" | grep -qiE \
    'rm[[:space:]]+-[rRfF]{1,3}[[:space:]]+/|diskutil[[:space:]]+(eraseDisk|zeroDisk|secureerase)|dd[[:space:]]+if=|chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/|mkfs\.|> /dev/[sh]d[a-z]|shred[[:space:]]+/dev/'
}

# ── prompt builder ────────────────────────────────────────────────────────────
build_prompt() {
  cat <<PROMPT
${MODE_CTX}
System: ${SYSINFO}

Rules:
- ONE command only. No markdown fences. No preamble. No "Here is" or "Sure!".
- On the lines after the command, list every flag used as:  -x: what it does
- Very last line must be:  EFFECT: one plain-English sentence
- If the command could cause data loss or system damage, prepend the ENTIRE
  first line with [DESTRUCTIVE] and nothing else before the command.

Request: $1
PROMPT
}

# ── run ollama ────────────────────────────────────────────────────────────────
call_model() {
  build_prompt "$1" | ollama run "$MODEL" --think=false
}

# ── execute with safety gate ──────────────────────────────────────────────────
run_response() {
  local response="$1"
  local first_line
  first_line=$(echo "$response" | head -1)

  echo

  # tier 1 — model-flagged destructive
  if echo "$first_line" | grep -q "\[DESTRUCTIVE\]"; then
    echo -e "${RED}${BLD}⚠  DESTRUCTIVE OPERATION${RST}"
    echo -e "${YLW}${response}${RST}"
    echo
    printf "Type ${BLD}yes${RST} to run (anything else cancels): "
    read -r CONFIRM
    if [[ "$CONFIRM" == "yes" ]]; then
      local cmd="${first_line#\[DESTRUCTIVE\] }"
      echo -e "${DIM}running: ${cmd}${RST}"
      eval "$cmd"
    else
      echo -e "${DIM}cancelled.${RST}"
    fi

  # tier 2 — regex blocklist
  elif is_dangerous "$response"; then
    echo -e "${RED}${BLD}⛔  BLOCKED${RST} — matched dangerous pattern"
    echo -e "${DIM}${response}${RST}"

  # safe — normal confirmation
  else
    echo -e "${response}"
    echo
    printf "Run? ${DIM}(y/n)${RST}: "
    read -r CONFIRM
    if [[ "$CONFIRM" == "y" ]]; then
      echo -e "${DIM}running: ${first_line}${RST}"
      eval "$first_line"
    else
      echo -e "${DIM}cancelled.${RST}"
    fi
  fi

  echo
}

# ── check ollama is running ───────────────────────────────────────────────────
check_ollama() {
  if ! command -v ollama &>/dev/null; then
    echo -e "${RED}ollama not found.${RST} Install from https://ollama.com"
    exit 1
  fi
  if ! ollama list &>/dev/null; then
    echo -e "${RED}ollama is not running.${RST} Start it with: ollama serve"
    exit 1
  fi
  if ! ollama list | grep -q "$MODEL"; then
    echo -e "${YLW}Model '${MODEL}' not found locally. Pulling...${RST}"
    ollama pull "$MODEL"
  fi
}

# ── one-shot mode (single arg, no loop) ───────────────────────────────────────
oneshot() {
  check_ollama
  local response
  response=$(call_model "$1")
  run_response "$response"
}

# ── interactive loop ──────────────────────────────────────────────────────────
interactive() {
  check_ollama
  echo -e "${BLD}llm-agent${RST} ${DIM}${MACOS_VER} · ${CHIP} · ${MODEL} · mode: ${MODE}${RST}"
  echo -e "${DIM}type 'exit' to quit, '--mode=disk|net|proc|pkg' to switch mode${RST}"
  echo

  while true; do
    printf "${GRN}>>${RST} "
    read -r PROMPT

    [[ "$PROMPT" == "exit" || "$PROMPT" == "quit" ]] && break
    [[ -z "$PROMPT" ]] && continue

    # allow mode switching mid-session
    if [[ "$PROMPT" == --mode=* ]]; then
      MODE="${PROMPT#--mode=}"
      MODE_CTX="${MODES[$MODE]:-Generate safe, minimal zsh commands for macOS.}"
      echo -e "${DIM}switched to mode: ${MODE}${RST}"
      echo
      continue
    fi

    local response
    response=$(call_model "$PROMPT")
    run_response "$response"
  done

  echo -e "${DIM}bye.${RST}"
}

# ── entrypoint ────────────────────────────────────────────────────────────────
if [[ -n "$ONESHOT_PROMPT" ]]; then
  oneshot "$ONESHOT_PROMPT"
else
  interactive
fi
