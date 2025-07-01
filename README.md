# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) and [Ansible](https://www.ansible.com/).

## Overview

This repository uses a hybrid approach:
- **Chezmoi**: Manages dotfile templating and deployment
- **Ansible**: Handles system package installation and configuration

## Prerequisites

- Ubuntu/Debian-based system (including WSL)
- `git` and `curl` installed

## Installation

### Linux/WSL

```bash
# Clone and apply dotfiles
chezmoi init --apply <your-github-username>
```

This will:
1. Clone your dotfiles
2. Install Ansible (if not present)
3. Run the Ansible playbook to install all packages
4. Apply your dotfiles

### Windows

For Windows-native shells and terminal setup:

```powershell
# Run the Windows setup script
.\windows\setup.ps1
```

This installs:
- Fish shell
- Nushell
- Starship prompt
- JetBrainsMono Nerd Font

## What's Included

### Shells
- **Bash**: Enhanced with aliases and functions
- **Fish**: Modern shell with autosuggestions
- **Nushell**: Data-oriented shell

### Developer Tools
- **Starship**: Cross-shell prompt
- **ripgrep** (`rg`): Fast grep replacement
- **bat**: Better `cat` with syntax highlighting
- **eza**: Modern `ls` replacement
- **fd**: Fast `find` replacement
- **fnm**: Fast Node.js version manager

### Configuration

Edit `.chezmoi.toml` to customize:
```toml
[data]
    name = "Your Name"
    email = "your.email@example.com"
    githubUser = "yourusername"
    editor = "nano"
    defaultShell = "nu"
```

## Updates

To update packages and dotfiles:

```bash
chezmoi update
```

## Structure

```
.
├── .chezmoi.toml           # User configuration
├── .chezmoiscripts/        # Chezmoi hooks
│   ├── run_once_01-install-ansible.sh
│   └── run_after_02-ansible-playbook.sh
├── ansible/                # Ansible configuration
│   ├── playbook.yml        # Main playbook
│   ├── requirements.yml    # Galaxy dependencies
│   └── templates/          # Shell configurations
├── dot_config/             # Application configs
│   ├── fish/
│   ├── nushell/
│   └── starship.toml
├── dot_bashrc              # Bash configuration
└── windows/                # Windows setup
    └── setup.ps1
```

## Troubleshooting

### Force Ansible re-run

```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Manual Ansible run

```bash
cd ~/.local/share/chezmoi/ansible
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass
```