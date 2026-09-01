# tmux Agents Manager

Pick supported agent panes in the current tmux session from a popup picker. The picker shows normalized status, an agent icon, location, title, and path; it can preview, focus, or kill a pane.

## Supported agents

The built-in identities and icons are:

| Agent | Default command | Icon |
| --- | --- | --- |
| Claude Code | `claude` | `◈` |
| Codex CLI | `codex` | `◉` |
| pi | `pi` | `π` |
| oh-my-pi | `oh-my-pi` | `✦` |
| Hermes | `hermes` | `♞` |

Feynman is detected separately from pi and uses the `ƒ` icon. Its default process aliases are `feynman` and `feynman.js`.

Only these six identities are listed. Ordinary shells and unrelated processes are omitted.

## Prerequisites

- tmux >= 3.2 (for `display-popup`)
- [fzf](https://github.com/junegunn/fzf)
- Bash >= 4. macOS ships Bash 3.2, so install a newer Bash and ensure it appears first on `PATH`.

## Install

Load the plugin entrypoint from your tmux configuration:

```tmux
run-shell ~/path/to/tmux-agents-manager/tmux-agents-manager.tmux
```

Reload tmux with `tmux source ~/.tmux.conf` or restart it. Start agents manually in panes; this plugin does not create or attach agent sessions.

## Usage

The default binding is `prefix` + `a`. It opens a popup containing recognized panes from the current tmux session only. A pane in another session is never included.

Inside the picker:

| Key | Action |
| --- | --- |
| `Enter` | Switch the originating client to the selected pane |
| `Ctrl-X` | Kill the selected pane and reload the list |
| Up/Down or typing | Navigate and filter with fzf |

The pane id is kept in a hidden first column for preview, kill, and jump actions. Displayed rows use status, agent icon, location, title, and path; agent names are intentionally not shown.

## Detection

Discovery uses two steps:

1. Match tmux's `pane_current_command` exactly against the configured aliases.
2. For an unmatched pane, inspect the pane process and descendants in its terminal's foreground process group.

The second step matches only an executable, an `env` command position, or a Node.js/Bun script position, so unrelated arguments and background jobs are omitted. `--list` prints picker rows without starting fzf, which is useful for scripts and smoke checks.

## Status helper

Status is stored per pane in `@agent_state`. Missing or unknown values render as idle. Accepted values are `working`, `waiting`, and `idle`; any other argument is normalized to `idle`.

Call the helper from an agent's own hook or event mechanism (hooks are not installed automatically):

```sh
/path/to/plugin/scripts/state.sh working
/path/to/plugin/scripts/state.sh waiting
/path/to/plugin/scripts/state.sh idle
```

The helper uses `TMUX_PANE` and is a no-op outside tmux.

## Options

Available options:

| Option | Default | Purpose |
| --- | --- | --- |
| `@agent_list_key` | `a` | Prefix key that opens the picker |
| `@agent_popup_width` | `90%` | Popup width |
| `@agent_popup_height` | `90%` | Popup height |
| `@agent_commands` | built-in aliases | Comma-separated `identity=command1|command2` alias overrides |
| `@agent_icons` | built-in icons above | Comma-separated `identity=icon` values |

Built-in aliases are `claude`, `codex`, `pi`, `oh-my-pi|omp`, `hermes`, and `feynman|feynman.js`. Omitting an identity preserves its built-ins; assigning aliases replaces them, and an empty assignment disables that identity. For example:

```tmux
set -g @agent_list_key 'u'
set -g @agent_popup_width '80%'
set -g @agent_commands 'claude=claude|claude-code,codex=codex|codex-cli'
set -g @agent_icons 'claude=◆,codex=◉,pi=π,oh-my-pi=✦,hermes=♞'
```

## License

[MIT](LICENSE) © Takuya Matsuyama
