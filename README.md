# Chezmoi Dotfiles

A secure, cross-platform dotfiles configuration managed by [chezmoi](https://www.chezmoi.io/) with modern shell support and development tools.

## 🚀 Features

- **Multi-shell support**: Bash, Zsh, Fish, Nushell, PowerShell
- **[Starship](https://starship.rs/)** prompt with Cyberpunk theme
- **Modern CLI tools**: bat, ripgrep, fd, lsd, delta
- **Cross-platform**: Windows, macOS, Linux, WSL
- **Security-first**: Proper secret handling and .gitignore
- **Automatic tool installation** via chezmoi externals
- **WSL integration** with Windows interop

## 🎯 Quick Start

### One-line Install

```bash
# Linux/macOS/WSL
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME

# Windows (PowerShell as Admin)
winget install twpayne.chezmoi
chezmoi init --apply $GITHUB_USERNAME
```

### Manual Setup

1. **Install chezmoi**:
   ```bash
   # macOS
   brew install chezmoi
   
   # Linux
   sh -c "$(curl -fsLS get.chezmoi.io)"
   
   # Windows
   winget install twpayne.chezmoi
   # or
   choco install chezmoi
   ```

2. **Initialize dotfiles**:
   ```bash
   chezmoi init https://github.com/yourusername/dotfiles.git
   ```

3. **Review changes** (optional):
   ```bash
   chezmoi diff
   ```

4. **Apply configuration**:
   ```bash
   chezmoi apply
   ```

5. **Post-install** (Nushell only):
   ```nu
   mkdir ($nu.data-dir | path join "vendor/autoload")
   starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
   ```

## 🔐 Security

### Secrets Management

This configuration properly handles secrets:

- **SSH keys** are never stored in the repo
- **Cloud credentials** (.aws, .gcloud, etc.) are ignored
- **API tokens** and passwords are excluded
- **Encryption support** for sensitive data (using age or gpg)

To add an encrypted secret:
```bash
# Using age encryption (recommended)
chezmoi add --encrypt ~/.ssh/config

# Using GPG
chezmoi add --encrypt --symmetric ~/.netrc
```

### First-time Setup

You'll be prompted for:
- Your full name
- Email address
- GitHub username
- Preferred editor
- (Automatic WSL detection)

## 📁 Structure

```
.
├── .chezmoi.toml.tmpl              # User configuration template
├── .chezmoiexternal.toml           # External tool management
├── .chezmoiignore                  # Security exclusions
├── .chezmoitemplates/              # Shared templates
│   ├── shell-common                # Common aliases/exports
│   ├── shell-functions             # Shared functions
│   └── wsl-integration             # WSL-specific settings
├── .chezmoiscripts/
│   ├── run_after_install-packages.sh.tmpl
│   └── run_after_validate.sh.tmpl
├── dot_config/
│   ├── starship.toml               # Starship prompt config
│   ├── fish/config.fish            # Fish shell
│   ├── nushell/config.nu           # Nushell
│   └── powershell/profile.ps1.tmpl # PowerShell
├── dot_bashrc.tmpl                 # Bash config
└── dot_zshrc.tmpl                  # Zsh config
```

## 🛠️ Included Tools

### Shells
- **Bash/Zsh**: Enhanced with completions and history
- **Fish**: Modern, user-friendly shell
- **Nushell**: Data-driven shell
- **PowerShell**: Cross-platform automation

### CLI Enhancements
- **starship**: Fast, customizable prompt
- **bat**: Syntax-highlighted cat
- **ripgrep (rg)**: Ultra-fast grep
- **fd**: User-friendly find
- **lsd**: Modern ls with icons
- **delta**: Better git diffs

## 🎨 Customization

### Local Overrides

Each shell sources a local config if present:
- `~/.bashrc.local`
- `~/.zshrc.local`
- `~/.config/fish/config.local.fish`
- `~/.config/powershell/profile.local.ps1`

### Starship Theme

The Cyberpunk theme features:
- 🛡️ Knight shield icon
- Yellow/cyan color scheme
- Git status with icons
- Language version detection
- Command duration
- Memory usage warnings

### WSL Integration

Automatic detection and configuration:
- Windows browser integration
- Clipboard support (pbcopy/pbpaste)
- Explorer.exe aliases
- WSLg GUI app support

## 🔧 Maintenance

### Update dotfiles
```bash
chezmoi update
```

### Edit configuration
```bash
chezmoi edit ~/.bashrc
chezmoi apply
```

### Add new files
```bash
chezmoi add ~/.config/newapp/config
```

### Re-run installation
```bash
chezmoi apply --refresh-externals
```

## 📝 Troubleshooting

Run validation to check your setup:
```bash
~/.local/share/chezmoi/.chezmoiscripts/run_after_validate.sh
```

Common issues:
- **Fonts not showing**: Select "JetBrainsMono Nerd Font" in terminal
- **Command not found**: Ensure `~/.local/bin` is in PATH
- **WSL clipboard**: Install `wslu` package

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with `chezmoi apply --dry-run`
4. Submit a pull request

## 📄 License

MIT
