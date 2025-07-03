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

### Quick Start (Linux/WSL)

#### 1. Install Chezmoi

```bash
# Option A: Using curl (recommended)
sh -c "$(curl -fsLS get.chezmoi.io)"

# Option B: Using package manager
# Ubuntu/Debian
sudo apt install chezmoi

# Arch
sudo pacman -S chezmoi
```

#### 2. Initialize and Apply Dotfiles

```bash
# Clone and apply dotfiles in one command
chezmoi init --apply <your-github-username>

# Or step by step:
chezmoi init <your-github-username>
chezmoi diff  # Preview changes
chezmoi apply # Apply changes
```

This will:
1. Clone your dotfiles repository
2. Install Ansible automatically (if not present)
3. Run the Ansible playbook to install all packages and tools
4. Apply all dotfile configurations
5. Configure your shells with proper PATH management

### Windows

#### Prerequisites
- Windows 10/11 with winget (Windows Package Manager)
- PowerShell Core (pwsh)

#### Installation

1. **Install PowerShell Core and Chezmoi** (in Windows PowerShell or Command Prompt):
```powershell
# Install PowerShell Core
winget install --id Microsoft.PowerShell --source winget

# Install Chezmoi
winget install twpayne.chezmoi
```

2. **Initialize and apply dotfiles** (in PowerShell Core):
```powershell
# Open PowerShell Core
pwsh

# Initialize and apply in one command
chezmoi init --apply <your-github-username>
```

This will automatically:
- Install Nushell and Starship prompt
- Install JetBrainsMono Nerd Font
- Configure Windows Terminal settings
- Install development tools and packages
- Set up your shells with proper PATH management
- Enable Starship prompt in all shells (PowerShell, Nushell)

**Note**: Some installations may require administrator privileges. If prompted, allow the installations to proceed.

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
│   ├── run_once_00-windows-check-pwsh.ps1.tmpl  # Windows: PowerShell Core check
│   ├── run_once_01-install-ansible.sh           # Linux/WSL: Ansible installer
│   ├── run_once_01-windows-initial-setup.ps1.tmpl # Windows: Initial setup
│   ├── run_after_02-ansible-playbook.sh         # Linux/WSL: Run Ansible
│   ├── run_onchange_02-windows-packages.ps1.tmpl # Windows: Package installer
│   └── run_after_03-windows-config.ps1.tmpl     # Windows: Post-config
├── .ansible/               # Ansible configuration (hidden)
│   ├── playbook.yml        # Main playbook
│   ├── requirements.yml    # Galaxy dependencies
│   └── templates/          # Shell configurations
├── dot_config/             # Application configs
│   ├── fish/
│   ├── nushell/
│   └── starship.toml
├── dot_bashrc              # Bash configuration
├── AppData/                # Windows application data
│   └── Local/Packages/     # Windows Terminal settings
└── .windows/               # Windows-specific resources (hidden)
    └── setup.ps1           # Manual setup script (legacy)
```

## Shell Configuration

After installation, your shells are configured with:

- **Automatic PATH management**: System paths are preserved and user paths are properly integrated
- **Cross-shell compatibility**: Consistent environment across Bash, Fish, and Nushell
- **Starship prompt**: Beautiful, informative prompt that works in all shells

To switch between shells:
```bash
# Set default shell
chsh -s $(which fish)    # Fish
chsh -s $(which nu)       # Nushell
chsh -s $(which bash)     # Bash

# Or just run the shell directly
fish
nu
bash
```

## Troubleshooting

### Common Issues

#### Missing commands after installation
If commands like `rg`, `bat`, or `eza` are not found:
```bash
# Reload your shell configuration
exec $SHELL

# Or source the configuration manually
source ~/.bashrc          # For Bash
source ~/.config/fish/config.fish  # For Fish
# Nushell reloads automatically
```

#### PATH issues
The dotfiles now handle PATH management automatically. If you have custom paths:
```bash
# Add to ~/.bashrc.local (Bash)
export PATH="$HOME/custom/bin:$PATH"

# Add to ~/.config/fish/config.local.fish (Fish)
fish_add_path $HOME/custom/bin

# Add to ~/.config/nushell/config.local.nu (Nushell)
$env.PATH = ($env.PATH | prepend $"($env.HOME)/custom/bin")
```

### Force Ansible re-run

If packages weren't installed correctly:
```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Manual Ansible run

For debugging or selective installation:
```bash
cd ~/.local/share/chezmoi/.ansible
ansible-playbook -i inventory.ini playbook.yml --ask-become-pass

# Run specific tags
ansible-playbook -i inventory.ini playbook.yml --tags "shell,tools" --ask-become-pass
```

### Verify installation

Check that all tools are installed:
```bash
# Run verification script
~/.local/share/chezmoi/.ansible/verify.sh

# Or check manually
command -v rg bat eza fd starship fnm
```