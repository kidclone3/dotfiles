# Dotfiles

## Installation

1. Clone with submodules:
```bash
git clone --recurse-submodules https://github.com/kidclone3/dotfiles.git
```

Or if you already cloned:
```bash
git submodule update --init --recursive
```

2. Set up your configuration files...

Use stow to symlink the configuration files into your home directory. For example, to set up the `zsh` configuration:

```bash
stow -vt ~ --no-folding zshrc
```

### Karabiner-Elements

Karabiner does not reload `karabiner.json` when the file itself is a symlink, so the whole
`~/.config/karabiner` directory must be the symlink. Stow it **without** `--no-folding`
(`~/.config/karabiner` must not exist beforehand), then restart the Karabiner agent once:

```bash
stow -vt ~ karabiner
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server
```

# References
https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df
https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation