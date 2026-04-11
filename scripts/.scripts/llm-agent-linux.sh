#!/bin/bash
# =============================================================================
#  llm-agent-linux.sh — Natural language CLI agent for Linux
#  Optimised for CPU-only inference on modest hardware (e.g. HP 450 G3)
#  Powered by Ollama + gemma3:4b (runs well on 16GB RAM, no GPU needed)
#
#  INSTALL
#  -------
#  1. Install Ollama:
#       curl -fsSL https://ollama.com/install.sh | sh
#  2. Pull the model:
#       ollama pull gemma3:4b
#  3. Make executable:
#       chmod +x llm-agent-linux.sh
#  4. (Optional) alias it:
#       echo 'alias ask="~/llm-agent-linux.sh"' >> ~/.bashrc && source ~/.bashrc
#
#  USAGE
#  -----
#  One-shot:      ./llm-agent-linux.sh "find what's eating disk space"
#  With mode:     ./llm-agent-linux.sh --mode=net "show open ports"
#  Interactive:   ./llm-agent-linux.sh
#  Custom model:  MODEL=gemma3:1b ./llm-agent-linux.sh "list running services"
#
#  MODES
#  -----
#  --mode=disk    Disk / filesystem commands
#  --mode=net     Network diagnostics
#  --mode=proc    Processes & systemd services
#  --mode=pkg     Package management (apt/dnf/pacman auto-detected)
#  --mode=sys     System info & hardware (sensors, cpu, memory)
#  (default)      General-purpose Linux commands
#
#  SAFETY
#  ------
#  Two-tier guard:
#    1. Model prefixes dangerous commands with [DESTRUCTIVE]
#       → requires typing "yes" in full to run
#    2. Regex blocklist catches what the model misses
#       → hard block, never executes
#
#  CPU PERFORMANCE TIPS
#  --------------------
#  - gemma3:4b is the sweet spot for this machine (~3–6s per response)
#  - gemma3:1b is faster (~1–2s) but less accurate on complex commands
#  - Set OLLAMA_NUM_THREAD to match your physical core count for best speed:
#      OLLAMA_NUM_THREAD=4 ollama serve   (run this before using the agent)
#  - Avoid running other heavy processes while the model is thinking
#
#  OUTPUT FORMAT
#  -------------
#  <command>
#  -f: what this flag does
#  EFFECT: one plain-English sentence
# =============================================================================

# ── model ─────────────────────────────────────────────────────────────────────
# gemma4:e2b — 2B param thinking model, good speed/quality balance on i7-6500U
# gemma3:1b  — faster fallback (~1-2s), use if e2b feels too slow
MODEL="${MODEL:-gemma4:e2b}"

# ── cpu threading ─────────────────────────────────────────────────────────────
# i7-6500U: 2 physical cores, 4 threads (hyperthreading)
# Setting this explicitly stops Ollama from underestimating on older hardware.
# If you ever run this on a different machine, change to match its thread count.
export OLLAMA_NUM_THREAD=4

# ── colours ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
YLW='\033[0;33m'
GRN='\033[0;32m'
DIM='\033[2m'
BLD='\033[1m'
RST='\033[0m'

# ── system detection ──────────────────────────────────────────────────────────
DISTRO=$(lsb_release -sd 2>/dev/null \
  || grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' \
  || echo "Linux")
KERNEL=$(uname -r)
ARCH=$(uname -m)
SHELL_NAME=$(basename "$SHELL")
RAM_GB=$(( $(grep MemTotal /proc/meminfo | awk '{print $2}') / 1024 / 1024 ))
CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
CPU_CORES=$(nproc)

# package manager — detect once
if   command -v apt    &>/dev/null; then PKG_MGR="apt"
elif command -v dnf    &>/dev/null; then PKG_MGR="dnf"
elif command -v pacman &>/dev/null; then PKG_MGR="pacman"
elif command -v zypper &>/dev/null; then PKG_MGR="zypper"
elif command -v yum    &>/dev/null; then PKG_MGR="yum"
else                                     PKG_MGR="unknown"
fi

SYSINFO="${DISTRO}, kernel: ${KERNEL}, arch: ${ARCH}, shell: ${SHELL_NAME}, pkg: ${PKG_MGR}, RAM: ${RAM_GB}GB, CPU: ${CPU_MODEL} (${CPU_CORES} cores)"

# ── tool inventory ────────────────────────────────────────────────────────────
# Scans once at startup. Combines Linux builtins + common third-party tools
# + package-manager installed list. Injected into every prompt.
build_tool_inventory() {
  local available=()

  # Linux builtins — always present
  local builtins=(
    bash sh uname ls cat head tail grep sed awk find sort uniq cut tr wc
    df du mount umount lsblk blkid fdisk parted
    ps top kill pkill pgrep nice renice nohup
    ip ifconfig ss netstat ping traceroute dig nslookup curl wget
    ssh scp sftp rsync
    tar gzip gunzip bzip2 xz zip unzip
    chmod chown chgrp ln cp mv rm mkdir rmdir touch
    systemctl journalctl service
    useradd usermod userdel groupadd passwd
    cron crontab at
    env export printenv which whereis type
    date cal uptime who w last
    lsof strace ltrace
    dmesg lspci lsusb lshw
    free vmstat iostat mpstat sar
    man info help
  )
  available+=("${builtins[@]}")

  # common third-party tools worth knowing about
  local third_party=(
    git vim nvim nano emacs tmux screen
    python3 pip3 node npm yarn ruby gem go rustc cargo
    docker kubectl helm terraform ansible
    htop btop atop iotop iftop nethogs
    ncdu tree bat fd rg fzf jq yq
    nmap netcat nc socat tcpdump wireshark
    ffmpeg imagemagick pandoc
    gh sqlite3 redis-cli psql mysql mongosh
    sensors lm-sensors smartctl hdparm
    gcc g++ make cmake clang
    snap flatpak
  )
  for tool in "${third_party[@]}"; do
    command -v "$tool" &>/dev/null && available+=("$tool")
  done

  # package-manager installed list (fast — reads cached db)
  case "$PKG_MGR" in
    apt)
      while IFS= read -r pkg; do
        [[ -n "$pkg" ]] && available+=("$pkg")
      done < <(dpkg --get-selections 2>/dev/null | grep -v deinstall | awk '{print $1}' | cut -d: -f1)
      ;;
    dnf|yum)
      while IFS= read -r pkg; do
        [[ -n "$pkg" ]] && available+=("$pkg")
      done < <(rpm -qa --qf '%{NAME}\n' 2>/dev/null)
      ;;
    pacman)
      while IFS= read -r pkg; do
        [[ -n "$pkg" ]] && available+=("$pkg")
      done < <(pacman -Qq 2>/dev/null)
      ;;
  esac

  # deduplicate, sort, join
  TOOL_INVENTORY=$(printf '%s\n' "${available[@]}" | sort -u | tr '\n' ',' | sed 's/,$//')
}

echo -e "${DIM}scanning tools...${RST}"
build_tool_inventory

# ── mode definitions (short = fewer tokens = faster on CPU) ──────────────────
declare -A MODES
MODES[disk]="Linux disk/filesystem commands. Use: du, df, lsblk, fdisk -l, ncdu, find -size. No deletion."
MODES[net]="Linux network commands. Use: ip, ss, netstat, lsof -i, nmap, ping, dig, curl, tcpdump."
MODES[proc]="Linux process/service commands. Use: ps, top, htop, kill, systemctl, journalctl, lsof."
MODES[pkg]="Package management with ${PKG_MGR} only. Common operations: install, remove, update, search, list."
MODES[sys]="Linux system info commands. Use: lscpu, lspci, lsusb, lshw, sensors, free, vmstat, dmesg, uname."

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

MODE_CTX="${MODES[$MODE]:-Safe, minimal bash commands for Linux. Prefer built-in tools.}"

# ── safety: regex blocklist ───────────────────────────────────────────────────
is_dangerous() {
  echo "$1" | grep -qiE \
    'rm[[:space:]]+-[rRfF]{1,3}[[:space:]]+/|dd[[:space:]]+if=.*of=/dev/[sh]d|mkfs\.[a-z]+[[:space:]]+/dev/[sh]d[a-z][^0-9]|chmod[[:space:]]+-R[[:space:]]+777[[:space:]]+/|:[[:space:]]*\(\)[[:space:]]*\{|> /dev/[sh]d[a-z][^0-9]|shred[[:space:]]+/dev/|wipefs[[:space:]]+-a[[:space:]]+/dev/[sh]d[a-z][^0-9]'
}

# ── tool availability check ───────────────────────────────────────────────────
check_tool_available() {
  local cmd="$1"
  cmd="${cmd#\[DESTRUCTIVE\] }"
  local binary
  binary=$(echo "$cmd" | awk '{print $1}' | xargs basename 2>/dev/null)
  [[ -z "$binary" ]] && return 0
  command -v "$binary" &>/dev/null
}

# ── prompt builder ────────────────────────────────────────────────────────────
# Kept lean on purpose — shorter prompts = faster CPU inference.
# Numbered rules are easier for smaller models to follow than prose paragraphs.
build_prompt() {
  cat <<PROMPT
System: ${SYSINFO}
Mode: ${MODE_CTX}
Available tools: ${TOOL_INVENTORY}

Rules:
1. Line 1: ONE shell command only. No markdown. No preamble. No "Here is".
2. Only use tools from the available list.
3. Lines 2+: each flag as "-x: meaning"
4. Last line: "EFFECT: one sentence"
5. If dangerous: start line 1 with [DESTRUCTIVE]

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

  # tool availability check
  if ! check_tool_available "$first_line"; then
    local binary
    binary=$(echo "${first_line#\[DESTRUCTIVE\] }" | awk '{print $1}' | xargs basename 2>/dev/null)
    echo -e "${YLW}${BLD}Tool not available:${RST} ${YLW}'${binary}' is not installed.${RST}"
    echo -e "${DIM}suggested: ${first_line}${RST}"
    case "$PKG_MGR" in
      apt)    echo -e "${DIM}install:   sudo apt install ${binary}${RST}" ;;
      dnf)    echo -e "${DIM}install:   sudo dnf install ${binary}${RST}" ;;
      pacman) echo -e "${DIM}install:   sudo pacman -S ${binary}${RST}" ;;
      *)      echo -e "${DIM}install it with your package manager${RST}" ;;
    esac
    echo
    return
  fi

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
    echo -e "${RED}ollama not found.${RST}"
    echo -e "Install with: ${BLD}curl -fsSL https://ollama.com/install.sh | sh${RST}"
    exit 1
  fi
  if ! ollama list &>/dev/null; then
    echo -e "${RED}ollama is not running.${RST} Start it with: ${BLD}ollama serve${RST}"
    exit 1
  fi
  if ! ollama list | grep -q "${MODEL%%:*}"; then
    echo -e "${YLW}Model '${MODEL}' not found locally. Pulling...${RST}"
    ollama pull "$MODEL"
  fi
}

# ── one-shot mode ─────────────────────────────────────────────────────────────
oneshot() {
  check_ollama
  local response
  response=$(call_model "$1")
  run_response "$response"
}

# ── interactive loop ──────────────────────────────────────────────────────────
interactive() {
  check_ollama
  echo -e "${BLD}llm-agent${RST} ${DIM}${DISTRO} · ${ARCH} · ${MODEL} · mode: ${MODE}${RST}"
  echo -e "${DIM}type 'exit' to quit  ·  '--mode=disk|net|proc|pkg|sys' to switch mode${RST}"
  echo

  while true; do
    printf "${GRN}>>${RST} "
    read -r PROMPT

    [[ "$PROMPT" == "exit" || "$PROMPT" == "quit" ]] && break
    [[ -z "$PROMPT" ]] && continue

    if [[ "$PROMPT" == --mode=* ]]; then
      MODE="${PROMPT#--mode=}"
      MODE_CTX="${MODES[$MODE]:-Safe, minimal bash commands for Linux.}"
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
