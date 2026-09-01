# tmux Agents Manager Implementation Plan

## Goal

Rename the tmux extension to `tmux-agents-manager` and recognize Codex CLI panes alongside the existing supported agents.

## File boundaries

- `tmux/tmux-claude-session-manager/` → `tmux/tmux-agents-manager/`: cleanly rename the extension directory and its entrypoint to `tmux-agents-manager.tmux`; remove Claude-specific plugin naming and legacy option fallbacks while preserving generic `@agent_*` behavior.
- `tmux/tmux-agents-manager/scripts/picker.sh`: add the `codex` identity, command alias, icon, and default enablement without broad substring matching.
- `tmux/tmux-agents-manager/tests/test_picker.sh`: exercise the real picker against controlled tmux/process command fixtures, covering direct and wrapped Codex processes plus unrelated-pane exclusion.
- `tmux/.tmux.conf` and `tmux/tmux-agents-manager/README.md`: point installation at the renamed entrypoint and document Codex/default options.

## Shared interfaces

- The executable plugin entrypoint is `tmux/tmux-agents-manager/tmux-agents-manager.tmux`.
- `@agent_commands` defaults include `codex`; users can override it with `codex=command1|command2` using the existing identity-alias syntax.
- `picker.sh --list` keeps its existing tab-separated row contract and represents Codex with its built-in icon.

## Acceptance checks

1. A pane whose `pane_current_command` is exactly `codex` appears in `picker.sh --list`.
2. A wrapper pane whose process arguments contain the Codex executable appears, while unrelated shell panes remain omitted.
3. Existing Claude, pi, oh-my-pi, Hermes, and Feynman identities remain supported.
4. The repository's tmux configuration loads only the renamed extension entrypoint, with no stale `tmux-claude-session-manager` or `claude_session_manager.tmux` references.
5. The renamed entrypoint can be sourced by tmux and installs the configured binding.

## Verification command

```sh
rtk bash tmux/tmux-agents-manager/tests/test_picker.sh
for file in tmux/tmux-agents-manager/*.tmux tmux/tmux-agents-manager/scripts/*.sh tmux/tmux-agents-manager/tests/*.sh; do rtk bash -n "$file"; done
rtk tmux -L agents-manager-test -f tmux/.tmux.conf new-session -d -s verify
rtk tmux -L agents-manager-test list-keys -T prefix a
rtk tmux -L agents-manager-test kill-server
```
