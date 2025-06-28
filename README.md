# Andre's Dotfiles

Cross-platform terminal configuration managed with [chezmoi](https://www.chezmoi.io/). Sets up a modern shell environment with Nushell, Fish, Starship prompt, and JetBrains Mono Nerd Font.

## 🚀 Quick Start

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/YOUR_USERNAME/dotfiles.git

# Or if chezmoi is already installed
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git
```

## 🎯 What Gets Installed

### All Platforms
- **[JetBrains Mono Nerd Font](https://www.nerdfonts.com/)** - Terminal font with icons
- **[Starship](https://starship.rs/)** - Fast, customizable prompt
- **[Nushell](https://www.nushell.sh/)** - Modern shell with structured data
- **[Fish](https://fishshell.com/)** - User-friendly shell (not on Windows native)

### Platform-Specific Behavior

| Platform | Package Manager | Font Location | Default Shell |
|----------|----------------|---------------|---------------|
| Windows | winget | `%LOCALAPPDATA%\Microsoft\Windows\Fonts` | PowerShell |
| macOS | Homebrew | `~/Library/Fonts` | zsh |
| Linux | apt/dnf/pacman/zypper | System fonts | bash |

*Note: Nushell can be set as default shell on all platforms (opt-out with `KEEP_CURRENT_SHELL=1`)*

## 📁 Configuration Structure

```
~/.config/
├── starship.toml             # Default Starship config (Unix shells)
├── starship-powershell.toml  # PowerShell-specific (no line break)
├── starship-nu.toml          # DEPRECATED - kept for reference
├── nushell/
│   ├── config.nu             # Nushell configuration
│   └── env.nu                # Nushell environment
├── fish/
│   └── config.fish           # Fish configuration
└── powershell/
    └── profile.ps1           # PowerShell profile (symlinked)
```

### Starship Configuration

- **Unix shells** (Bash, Zsh, Fish, Nushell): Use `starship.toml` with cursor on new line
- **PowerShell**: Uses `starship-powershell.toml` with cursor on same line

## 🔧 Installation Details

### Windows
- Installs via winget (falls back to manual)
- Creates PowerShell profile symlink
- Detects Git Bash and WSL for additional configuration
- Requires Developer Mode or Admin for symlinks

### macOS
- Installs via Homebrew (falls back to official installers)
- Configures Bash (`.bash_profile`) and Zsh (`.zshrc`)
- Works with both Intel and Apple Silicon

### Linux
- Auto-detects distribution package manager
- Downloads latest binaries for Starship and Nushell
- Supports x86_64, aarch64, and armv7l architectures
- Configures shells without requiring root (uses `sudo` when available)

## 🛠️ Advanced Usage

### Force Re-run Installation Scripts
```bash
# Remove chezmoi's record of running the scripts
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Skip Setting Nushell as Default Shell
```bash
KEEP_CURRENT_SHELL=1 chezmoi apply
```

### Update Configuration
```bash
# Pull latest changes and apply
chezmoi update

# Edit configuration
chezmoi edit ~/.config/starship.toml
chezmoi apply
```

### Testing Changes
```bash
# See what would change without applying
chezmoi diff

# Dry run with verbose output
chezmoi apply --dry-run --verbose
```

## 🐚 Shell Configuration

### Configured Shells
- **Bash**: Starship prompt auto-configured
- **Zsh**: Starship prompt auto-configured (macOS)
- **Fish**: Starship prompt auto-configured
- **Nushell**: Starship configured via chezmoi-managed files
- **PowerShell**: Profile symlinked, uses separate Starship config

### Manual Shell Configuration
If automatic configuration fails, add to your shell's RC file:

```bash
# Bash (~/.bashrc)
eval "$(starship init bash)"

# Zsh (~/.zshrc)
eval "$(starship init zsh)"

# Fish (~/.config/fish/config.fish)
starship init fish | source

# PowerShell ($PROFILE)
$ENV:STARSHIP_CONFIG = "$HOME\.config\starship-powershell.toml"
Invoke-Expression (&starship init powershell)
```

## 🎨 Customization

### Starship Theme
The included Starship configuration features a "Cyberpunk + Knight" theme with:
- Git status indicators
- Language/framework detection
- Command duration
- Time display
- Memory usage warnings
- Custom icons and colors

Edit `~/.config/starship.toml` to customize.

### Adding New Dotfiles
```bash
# Add a file to chezmoi management
chezmoi add ~/.config/myapp/config.yml

# Add with templating
chezmoi add --template ~/.gitconfig
```

## 🚨 Troubleshooting

### Windows Issues
- **"Winget not found"**: Install [App Installer](https://www.microsoft.com/p/app-installer/9nblggh4nns1) from Microsoft Store
- **Symlink fails**: Enable Developer Mode or run as Administrator
- **Fonts not showing**: Restart your terminal after installation

### Linux/macOS Issues
- **"sudo required"**: Install sudo or run as root
- **Architecture not supported**: Visit tool websites for manual installation
- **Font not found**: Run `fc-cache -fv` to refresh font cache

### General Issues
- **Starship not working**: Ensure it's in your PATH (`which starship`)
- **Nushell errors**: Check `~/.config/nushell/env.nu` exists
- **Icons not showing**: Ensure your terminal uses JetBrains Mono Nerd Font

## 📝 License

This repository is available under the [LICENSE](LICENSE) file.

## 🤝 Contributing

Feel free to submit issues and PRs. Please test changes on all platforms when possible.

---

## Implementation Notes

### Script Features
- **Idempotent**: Safe to run multiple times
- **Error handling**: Graceful failures with helpful messages
- **Network resilience**: Handles connection issues
- **Cross-platform**: OS-specific logic via chezmoi templates
- **Progress feedback**: Clear status messages with emoji indicators

### File Management
- `.chezmoiignore`: Prevents OS-specific files from being applied on wrong platforms
- `.chezmoiscripts/`: Contains `run_before_` scripts that execute before file application
- Template files (`.tmpl`): Enable conditional logic based on OS/arch

### Deprecated Files
- `starship-nu.toml`: No longer used, all Unix shells use `starship.toml`
- `starship-theme-manager.nu`: Removed, was for testing different prompts
