# Chezmoi Cross-Platform Setup

## 📁 Structure Overview

```
~/.local/share/chezmoi/
├── dot_config/
│   ├── starship.toml            # Base starship config (kept for reference)
│   ├── starship-powershell.toml # PowerShell-specific (no line break)
│   ├── starship-nu.toml         # Nu shell config (with line break)
│   ├── nushell/
│   │   ├── config.nu            # Nu config (loads starship)
│   │   └── env.nu               # Nu environment (sets STARSHIP_CONFIG)
│   └── fish/
│       └── config.fish          # Fish config (loads starship)
├── windows-terminal/
│   └── settings.json            # Windows Terminal config
├── readonly_OneDrive/readonly_Documents/PowerShell/
│   └── Microsoft.PowerShell_profile.ps1  # PowerShell profile
├── run_once_install-tools.ps1.tmpl       # Windows installer
└── run_once_install-tools.sh.tmpl        # Linux/macOS installer

```

## 🚀 What Gets Installed

### All Platforms
- ✅ JetBrainsMono Nerd Font
- ✅ Starship prompt
- ✅ Nu shell
- ✅ Fish shell (except Windows)

### Shell Initialization
| Shell | Config Location | Starship Init |
|-------|----------------|---------------|
| PowerShell | `$PROFILE` | ✅ Points to starship-powershell.toml |
| Nu | `~/.config/nushell/config.nu` | ✅ Points to starship-nu.toml |
| Fish | `~/.config/fish/config.fish` | ✅ Uses starship-nu.toml |

### Platform-Specific Package Managers
| OS | Font Install | Shell Install |
|----|--------------|---------------|
| Windows | winget | winget (nu only) |
| Ubuntu/Debian | apt | apt |
| Fedora | dnf | dnf |
| Arch | pacman | pacman |
| openSUSE | zypper | zypper |
| macOS | brew | brew |

## 🎯 Key Features

1. **Separate Starship Configs**
   - PowerShell: Cursor on same line
   - Nu/Fish: Cursor on new line

2. **Universal Paths**
   - `~/.config/starship-nu.toml` works everywhere
   - Chezmoi handles OS path differences

3. **Idempotent Scripts**
   - Safe to run multiple times
   - Checks before installing

4. **Graceful Fallbacks**
   - Manual download if package managers fail
   - Clear error messages

## 📝 Usage

```bash
# First time setup
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git

# Update existing
chezmoi update

# Force re-run installers (testing)
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## 🔧 Testing Checklist

- [ ] PowerShell loads correct starship config
- [ ] Nu shell loads correct starship config  
- [ ] Fish shell initializes starship
- [ ] Font displays all icons correctly
- [ ] Windows Terminal uses JetBrainsMono NF
- [ ] Scripts run without errors on fresh systems
