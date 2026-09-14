# Nvim & Zed Keybinding Reference

> `<leader>` = `Space` in both editors

---

## Unified Keybindings (Same in Both)

### Core Vim Motions
| Key | Action |
|---|---|
| `h` `j` `k` `l` | Left / Down / Up / Right |
| `w` `b` `e` | Next word / Prev word / End of word |
| `0` `$` `^` | Line start / Line end / First non-blank |
| `gg` / `G` | Top / Bottom of file |
| `f{c}` / `t{c}` | Find / Till character |
| `%` | Jump to matching bracket |
| `{` / `}` | Prev / Next paragraph |
| `Ctrl-d` / `Ctrl-u` | Half page down / up |

### Editing
| Key | Action |
|---|---|
| `i` `a` `o` | Insert / Append / Open line below |
| `I` `A` `O` | Insert at start / Append at end / Open line above |
| `d` `c` `y` + motion | Delete / Change / Yank |
| `dd` `cc` `yy` | Delete / Change / Yank line |
| `p` / `P` | Paste after / before |
| `u` / `Ctrl-r` | Undo / Redo |
| `.` | Repeat last change |
| `x` | Delete character |
| `r{c}` | Replace character |
| `~` | Toggle case |
| `J` | Join lines |
| `>` / `<` (visual) | Indent / Dedent |

### Visual Mode
| Key | Action |
|---|---|
| `v` | Visual character mode |
| `V` | Visual line mode |
| `Ctrl-v` | Visual block / multi-cursor |

### Search
| Key | Action |
|---|---|
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / Prev match |
| `*` / `#` | Search word under cursor fwd / bwd |

### Text Objects
| Key | Action |
|---|---|
| `iw` / `aw` | Inner / Around word |
| `i"` / `a"` | Inner / Around double quotes |
| `i'` / `a'` | Inner / Around single quotes |
| `i(` / `a(` | Inner / Around parentheses |
| `i{` / `a{` | Inner / Around braces |
| `i[` / `a[` | Inner / Around brackets |
| `it` / `at` | Inner / Around HTML tag |

### Surround (built-in in both)
| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |
| `Shift-S` (visual) | Surround selection |

### Comment Toggle (built-in in both)
| Key | Action |
|---|---|
| `gcc` | Toggle comment (line) |
| `gc` (visual) | Toggle comment (selection) |

### Marks & Registers
| Key | Action |
|---|---|
| `m{a-z}` | Set mark |
| `'{mark}` | Jump to mark |
| `"{reg}` | Use register |
| `q{reg}` / `@{reg}` | Record / Play macro |

### Command Mode
| Key | Action |
|---|---|
| `:w` | Save |
| `:q` | Quit / Close tab |
| `:wq` | Save and quit |
| `:vs` | Vertical split |
| `:sp` | Horizontal split |
| `:{number}` | Jump to line |

---

## Unified Custom Keybindings (Configured to Match)

### Leader — Save & Panels
| Key | Action | Zed | Neovim |
|---|---|---|---|
| `<leader>w` | Save file | `workspace::Save` | `:w<CR>` |
| `<leader>e` | File explorer | Project panel | Yazi |
| `<leader>a` | AI panel | `agent::ToggleFocus` | — |

### Leader — Fuzzy Finders (`<leader>f*`)
| Key | Action | Zed | Neovim |
|---|---|---|---|
| `<leader>ff` | Find files | `file_finder::Toggle` | `fzf-lua.files()` |
| `<leader>fg` | Project search / grep | `workspace::NewSearch` | `fzf-lua.live_grep()` |
| `<leader>fb` | Buffers / open tabs | `tab_switcher::Toggle` | `fzf-lua.buffers()` |
| `<leader>fx` | Diagnostics | `diagnostics::Deploy` | `fzf-lua.diagnostics_document()` |
| `<leader>fs` | Document symbols | `outline::Toggle` | `fzf-lua.lsp_document_symbols()` |
| `<leader>fw` | Workspace symbols | `project_symbols::Toggle` | `fzf-lua.lsp_workspace_symbols()` |

### LSP Navigation (bare `g` prefix)
| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gy` | Go to type definition |
| `gI` | Go to implementation |
| `gA` | Find all references |
| `gs` | Document symbols |
| `gS` | Workspace symbols |
| `K` | Hover documentation |

### LSP Actions
| Key | Action |
|---|---|
| `grn` | Rename symbol |
| `g.` | Code action |
| `gh` | Show diagnostic (hover) |

### Diagnostic Navigation
| Key | Action |
|---|---|
| `g]` | Next diagnostic |
| `g[` | Previous diagnostic |

### Navigation History (Jumplist)
| Key | Action |
|---|---|
| `Ctrl-o` | Jump back (built-in in both) |
| `Ctrl-i` | Jump forward (built-in in both) |

### Git Hunk Navigation
| Key | Action |
|---|---|
| `]c` | Next git hunk |
| `[c` | Previous git hunk |

### Line Movement
| Key | Mode | Action |
|---|---|---|
| `Alt-j` | Normal | Move current line down |
| `Alt-k` | Normal | Move current line up |
| `Alt-j` | Visual | Move selection down |
| `Alt-k` | Visual | Move selection up |

### Window / Pane Navigation
| Key | Action |
|---|---|
| `Ctrl-h` | Move to left pane |
| `Ctrl-j` | Move to bottom pane |
| `Ctrl-k` | Move to top pane |
| `Ctrl-l` | Move to right pane |

### Insert Mode
| Key | Action |
|---|---|
| `jj` | Escape to normal mode |

### Buffer / Tab Management
| Key | Action | Zed | Neovim |
|---|---|---|---|
| `<leader>bd` | Close buffer/tab | `pane::CloseActiveItem` | `mini.bufremove` |
| `<leader>td` | Toggle diagnostics | `editor::ToggleDiagnostics` | `vim.diagnostic.enable()` |
| `<leader>tt` | Terminal | `terminal_panel::ToggleFocus` | Floating terminal |

---

## Neovim-Only Keybindings

> These have no Zed equivalent or are Neovim-specific features.

### Editing Enhancements
| Key | Action |
|---|---|
| `<leader>p` (visual) | Paste without yanking selection |
| `<leader>d` | Delete without yanking |
| `Ctrl-a` | Select all + copy to clipboard |
| `n` / `N` | Next/prev search result (auto-centered) |
| `Ctrl-d` / `Ctrl-u` | Half page (auto-centered) |
| `J` | Join lines (cursor stays in place) |
| `<` / `>` (visual) | Indent and re-select |

### Splits
| Key | Action |
|---|---|
| `<leader>sv` | Vertical split |
| `<leader>sh` | Horizontal split |
| `Ctrl-Up/Down` | Resize height ±2 |
| `Ctrl-Left/Right` | Resize width ±2 |

### LSP Extras
| Key | Action |
|---|---|
| `<leader>gS` | Go to definition in vsplit |
| `<leader>gI` | Go to implementation in vsplit |
| `<leader>D` | Show line-scope diagnostic float |
| `<leader>oi` | Organize imports |
| `<leader>q` | Open diagnostic loclist |
| `<leader>dl` | Show line diagnostic float |

### LSP via fzf-lua (secondary access)
| Key | Action |
|---|---|
| `<leader>fr` | References (fzf picker) |
| `<leader>ft` | Type definitions (fzf picker) |
| `<leader>fi` | Implementations (fzf picker) |

### FZF Extras
| Key | Action |
|---|---|
| `<leader>fo` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fX` | Workspace diagnostics |

### Git (gitsigns)
| Key | Action |
|---|---|
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle inline blame |
| `<leader>hd` | Diff this |

### Utilities
| Key | Action |
|---|---|
| `<leader>pa` | Copy full file path |
| `<leader>t` | Toggle floating terminal |
| `Esc` (in terminal) | Close floating terminal |
| `<leader>c` | Clear search highlights |

---

## Zed-Only Keybindings

> These are Zed built-ins or features with no Neovim equivalent.

### Multi-Cursor
| Key | Action |
|---|---|
| `gl` | Add cursor at next match |
| `ga` | Select all matches |
| `g>` / `g<` | Skip / Unselect match |

### Pane & Navigation
| Key | Action |
|---|---|
| `g/` | Project search pane |
| `g<space>` | File finder pane |
| `Ctrl-w <space>` | File finder pane (alt) |
| `Ctrl-w gd` | Go to definition in split |
| `Ctrl-w gD` | Go to type def in split |

### Git (Zed-native)
| Key | Action |
|---|---|
| `do` | Obtain diff hunk (diffget) |
| `dO` | Obtain all diff hunks |
| `du` | Revert diff hunk |
| `dU` | Revert all diff hunks |
| `dp` | Put diff hunk (diffput) |

### Tree-sitter Motions
| Key | Action |
|---|---|
| `]m` / `[m` | Next / Prev method start |
| `]M` / `[M` | Next / Prev method end |
| `]]` / `[[` | Next / Prev class/section |
| `]x` / `[x` | Next / Prev conflict marker |
| `af` / `if` | Around / Inside function |
| `ac` / `ic` | Around / Inside class |
| `ia` / `aa` | Inside / Around argument |

### Insert Mode Completion
| Key | Action |
|---|---|
| `Ctrl-x Ctrl-o` | Trigger completion |
| `Ctrl-x Ctrl-c` | Request Copilot suggestion |
| `Ctrl-x Ctrl-a` | Open inline AI assistant |
| `Ctrl-x Ctrl-l` | Line completion |

### Built-in Plugin Features
| Key | Action |
|---|---|
| `gR` | Replace with register |
| `cx` | Exchange (vim-exchange) |
| `[-` `]+` `[=` etc. | Indent-wise motions |

### Command Palette Extras
| Command | Action |
|---|---|
| `:E` | Toggle file explorer |
| `:A` | Open AI panel |
| `:G` | Open Git panel |
| `:te` | Open terminal |
| `:cl` | Open diagnostics list |

---

## Muscle Memory Traps

| Situation | What Happens |
|---|---|
| Type `cd` in Neovim | **Does nothing** (was rename — now `grn`) |
| Type `grn` | **Rename symbol** in both editors |
| Type `gI` in Neovim | **Go to implementation** (not insert at col 0) |
| Type `]d` / `[d` | **Does nothing** — use `g]` / `g[` for diagnostics now |
| After `gI`/`gd`, want to go back | Use `Ctrl-o` (built-in both), **not** `:q` |
| `:q` after LSP jump | **Closes the buffer** — use `Ctrl-o` to jump back instead |
| `<leader>gI` in Neovim | Opens implementation in a **vsplit** — `:q` to close |
| Type `Ctrl-v` in Zed | Multi-cursor (real-time updates per line) |
| Regex in Zed `:s/` | Use `(group)` → `$1` (not `\(group\)` → `\1`) |
| `]c`/`[c` in Vim diff mode | **Conflicts** with git hunk navigation |
| `gL` in Zed | **Select previous match** (not select all — use `ga`) |
