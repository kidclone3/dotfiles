# Dotfiles Repository

## Rules

### Use $HOME Instead of Absolute Paths

**ALWAYS** use `$HOME` or `~` instead of hardcoded absolute paths like `/home/username`.

| Bad | Good |
|-----|------|
| `/home/duybk/.config` | `$HOME/.config` |
| `/home/user/.local/bin` | `$HOME/.local/bin` |

**Why:**
- Dotfiles are meant to be portable across machines
- Different users have different usernames
- Makes the config work on any system without modification

**Applies to:**
- Shell configs (`.zshrc`, `.bashrc`, `.custom.zshrc`)
- Tmux configs (`.tmux.conf`)
- All other dotfiles in this repo
