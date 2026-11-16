# Rex Shortcuts

Rex reads its shortcuts from `~/.config/rex/init.lua`. Sequences use `>` between
keystrokes, so `ctrl+b>c` means press `Ctrl+B`, release it, then press `c`.

## Tmux-style bindings

| Shortcut | Rex action | Notes |
| --- | --- | --- |
| `Ctrl+B`, `Ctrl+B` | Send `Ctrl+B` to the terminal | Passes the prefix through to programs that use it. |
| `Ctrl+B`, `r` | Reload Rex config | |
| `Ctrl+B`, `c` | New tab | Tmux calls this a new window. |
| `Ctrl+B`, `n` | New session | Rex opens its new-session flow; tmux prompts for a session name. |
| `Ctrl+B`, `o` | Switch session | Uses Rex's session picker instead of tmux's `sesh`/`fzf-tmux` command. |
| `Ctrl+B`, `|` | Split right | |
| `Ctrl+B`, `-` | Split down | |
| `Ctrl+B`, `h` / `j` / `k` / `l` | Focus left / down / up / right | |
| `Ctrl+B`, `m` | Toggle pane zoom | |
| `Ctrl+B`, `z` | Toggle pane zoom | Also matches tmux's default zoom shortcut. |
| `Ctrl+B`, `x` | Close pane | |
| `Ctrl+B`, `Ctrl+R`, then `m` | Toggle pane zoom | The repeat mode also exits with `Enter` or `Escape`. |

The prefix, splits, pane navigation, zoom, close, reload, new-session, and
session-switch bindings follow the tmux shortcuts in
[`.tmux.conf`](.tmux.conf) where Rex has a corresponding action. `Ctrl+B`,
`c` adds tmux's default new-window shortcut, mapped to a Rex tab.

Tmux copy mode and its popup/menu bindings do not have matching bindings in this
Rex config.

## Edit and reload

Edit `~/.config/rex/init.lua`, then check and reload it:

```sh
rex config check
rex config reload
```

## Official Rex documentation

- [Key Sequences](https://www.superlogical.com/rex/docs/customize/key-sequences) — sequence syntax and tmux-style examples.
- [Keyboard Shortcuts](https://www.superlogical.com/rex/docs/customize/keyboard-shortcuts) — `rex.bind`, key names, and reload behavior.
- [Configuration File](https://www.superlogical.com/rex/docs/customize/config) — config path, checking, and reload.
- [Mac Actions](https://www.superlogical.com/rex/docs/reference/mac-actions) — available Rex actions, including tabs, sessions, and panes.

Docs checked 2026-11-12.
