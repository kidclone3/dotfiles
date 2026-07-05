# tmux-claude-session-manager

Pick Claude Code panes in the **current** tmux session from a popup picker —
see which are working, waiting, or idle, preview their screen, and jump.

Unlike the original plugin (which created a dedicated tmux session per project),
this fork discovers Claude panes directly via `tmux list-panes`. You just open
Claude Code in whatever pane you want, and the picker finds it.

- 🎯 **Scoped to the current session** — in `genbook-api`, you only see
  `genbook-api` panes; other sessions are invisible.
- 🟢 **Live status** per pane — `working` / `waiting` / `idle` — driven by
  Claude Code hooks.
- 👁️ **Live preview** of each pane's screen in the picker.
- 🖱️ **Jump** — selecting a pane switches your client to it.

## Prerequisites

- **tmux ≥ 3.2** (for `display-popup`)
- **[fzf](https://github.com/junegunn/fzf)**
- **[Claude Code](https://claude.com/claude-code)** CLI
- bash; macOS or Linux

## Install

Clone and add a `run-shell` line to `~/.tmux.conf`:

```sh
git clone https://github.com/craftzdog/tmux-claude-session-manager ~/path/to/plugin
```

```tmux
run-shell ~/path/to/plugin/claude_session_manager.tmux
```

Reload: `tmux source ~/.tmux.conf` (or restart tmux).

## Usage

| Key          | Action                                                        |
| ------------ | ------------------------------------------------------------- |
| `prefix`+`a` | Open the pane picker in a popup                               |

Inside the picker:

| Key                       | Action         |
| ------------------------- | -------------- |
| `enter`                   | Jump to pane   |
| `ctrl-x`                  | Kill the highlighted pane |
| `↑` / `↓`, type to filter | fzf navigation |

## Status setup (optional, recommended)

Status is tracked per-pane via `@claude_state`. Wire `state.sh` into Claude Code
hooks so panes report their state automatically.

Add to your Claude Code settings (`~/.claude/settings.json`), adjusting the path
to match your clone location:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/path/to/plugin/scripts/state.sh working"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "~/path/to/plugin/scripts/state.sh waiting"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "~/path/to/plugin/scripts/state.sh waiting"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "~/path/to/plugin/scripts/state.sh idle"
          }
        ]
      }
    ]
  }
}
```

State machine:

| Event                            | Picker       | Meaning              |
| -------------------------------- | ------------ | -------------------- |
| `UserPromptSubmit`               | 🟡 `working` | Busy — leave it      |
| `Notification` (permission)      | 🟢 `waiting` | Needs permission     |
| `PreToolUse` (`AskUserQuestion`) | 🟢 `waiting` | Asking a question    |
| `Stop`                           | ⚪ `idle`    | Turn finished        |

Without hooks all panes show ⚪ `idle`.

## Options

| Option                  | Default | Description        |
| ----------------------- | ------- | ------------------ |
| `@claude_list_key`      | `a`     | prefix key: picker |
| `@claude_popup_width`   | `90%`   | popup width        |
| `@claude_popup_height`  | `90%`   | popup height       |

```tmux
set -g @claude_list_key 'u'
set -g @claude_popup_width '80%'
```

## Differences from upstream

| Aspect               | Upstream                              | This fork                            |
| -------------------- | ------------------------------------- | ------------------------------------ |
| Discovery            | tmux sessions named `claude-*`        | Any pane running `claude`            |
| Scope                | All sessions                          | Current session only (`-s` flag)      |
| Launch               | `prefix`+`y` creates a new session    | Removed — launch Claude however you want |
| State tracking       | Per-session (`@claude_state`)          | Per-pane (`-p` flag)                 |
| Default picker key   | `prefix`+`u`                          | `prefix`+`a`                         |
| Install              | TPM `@plugin` or manual `run-shell`   | `run-shell` only                     |

## License

[MIT](LICENSE) © Takuya Matsuyama
