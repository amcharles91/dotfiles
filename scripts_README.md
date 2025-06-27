# Chezmoi Font Installation Scripts

These scripts automatically install JetBrainsMono Nerd Font and Starship on new systems.

## Features
- **Cross-platform**: Windows (PowerShell), Linux (Bash), macOS (Bash)
- **Multiple package managers**: winget, scoop, brew, manual fallback
- **Idempotent**: Safe to run multiple times (checks if already installed)
- **Error handling**: Graceful fallbacks if primary methods fail
- **Cleanup**: Temporary files removed automatically

## Edge Cases Handled
1. **Font already installed**: Checks multiple locations before installing
2. **No package manager**: Falls back to manual download/install
3. **Permission issues**: Windows script requests admin, Linux/Mac use user fonts
4. **Network failures**: Error messages guide manual installation
5. **Different font locations**: Checks system and user font directories

## How It Works
- `run_once_` prefix means chezmoi only runs it once per machine
- `.tmpl` extension enables OS detection via `{{ if eq .chezmoi.os "..." }}`
- Scripts are executable after `chezmoi apply`

## Testing
```bash
# See what would run
chezmoi apply --dry-run --verbose

# Force re-run (for testing)
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```
