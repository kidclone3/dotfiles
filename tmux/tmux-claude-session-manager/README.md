# tmux Agent Session Manager

Pick supported agent panes in the current tmux session from a popup picker. The picker shows normalized status, an agent icon, location, title, and path; it can preview, focus, or kill a pane.

## Supported agents

The built-in identities and icons are:

| Agent | Default command | Icon |
| --- | --- | --- |
| Claude Code | `claude` | `◈` |
| pi | `pi` | `π` |
| oh-my-pi | `oh-my-pi` | `✦` |
| Hermes | `hermes` | `♞` |

Feynman is detected separately from pi and uses the `ƒ` icon. Its default process aliases are `feynman` and `feynman.js`.

Only these five identities are listed. Ordinary shells and unrelated processes are omitted.

## Prerequisites

- tmux >= 3.2 (for `display-popup`)
- [fzf](https://github.com/junegunn/fzf)
- bash on Linux or macOS

## Install

Load the existing entrypoint from your tmux configuration:

```tmux
run-shell ~/path/to/plugin/claude_session_manager.tmux
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
2. For an unmatched pane, inspect the pane process and foreground children with `ps` and match executable tokens in their command lines.

The second step recognizes wrappers that launch a supported agent without broad substring matching. `--list` prints the picker rows without starting fzf, which is useful for scripts and smoke checks.

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

Generic options are preferred:

| Option | Default | Purpose |
| --- | --- | --- |
| `@agent_list_key` | `a` | Prefix key that opens the picker |
| `@agent_popup_width` | `90%` | Popup width |
| `@agent_popup_height` | `90%` | Popup height |
| `@agent_commands` | `claude,pi,oh-my-pi,hermes` | Comma-separated command aliases |
| `@agent_icons` | built-in icons above | Comma-separated `identity=icon` values |

Command entries may assign aliases explicitly with `identity=command1|command2`, for example:

```tmux
set -g @agent_list_key 'u'
set -g @agent_popup_width '80%'
set -g @agent_commands 'claude=claude|claude-code,pi,oh-my-pi,hermes'
set -g @agent_icons 'claude=◆,pi=π,oh-my-pi=✦,hermes=♞'
```

For migration, popup and list settings also read legacy `@claude_list_key`, `@claude_popup_width`, and `@claude_popup_height` when their generic counterpart is unset. New configuration and state use `@agent_*`; the old `@claude_state` option is not read.

## License

[MIT](LICENSE) © Takuya Matsuyama
