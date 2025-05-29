# Dotfiles

## Installation

1. Clone with submodules:
```bash
git clone --recurse-submodules https://github.com/yourusername/dotfiles.git
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

# References
https://gist.github.com/n1snt/454b879b8f0b7995740ae04c5fb5b7df
https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation