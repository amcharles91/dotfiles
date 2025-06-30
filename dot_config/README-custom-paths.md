# Custom PATH Configuration

The file `~/.config/chezmoi-custom-paths.txt` allows you to add custom PATH entries that will be preserved across `chezmoi apply` operations.

## Security Notice

⚠️ **IMPORTANT**: Only add trusted directories to this file. Adding untrusted paths could allow execution of malicious programs.

## Usage

1. Edit `~/.config/chezmoi-custom-paths.txt`
2. Add one path per line (absolute paths only)
3. Lines starting with `#` are treated as comments
4. Only existing directories will be added to PATH (files are ignored)
5. Paths with special characters (spaces, quotes) are automatically escaped

## Example

```
# Development tools
/opt/custom-tools/bin
/home/andre/scripts

# Work-specific paths
/opt/company/bin
```

## Automatic PATH Additions

The following paths are automatically added if they exist:
- `~/.local/bin` (always first)
- `~/.cargo/bin` (Rust)
- `~/.npm-global/bin` (NPM global packages)
- `~/go/bin` (Go)
- `~/.bun/bin` (Bun)
- `/usr/games` and `/usr/local/games` (Linux only)
- `/snap/bin` (Linux with Snap)
- NVM paths (respects default version)
- `/usr/lib/wsl/lib` (WSL only)

## PATH Priority

Custom paths and development tools are **prepended** to PATH, giving them higher priority than system binaries. This ensures your custom tools take precedence.

## Notes

- Only directories are added (files are ignored for security)
- Paths are validated for existence before being added
- Duplicate paths are automatically prevented
- The order matters: paths are prepended in the order listed
- Changes take effect after running `chezmoi apply` and restarting your shell

## NVM Version Selection

The NVM setup respects your default version set with `nvm alias default <version>`. If no default is set, it falls back to the lexically latest version (note: v10.x would sort after v9.x due to alphabetical sorting). For accurate version selection, always set a default:

```bash
nvm alias default node  # Use latest
nvm alias default 18    # Use specific version
```