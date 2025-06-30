# env.nu
#
# Installed by:
# version = "0.105.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# Add ~/.local/bin to PATH if not already present
$env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.HOME)/.local/bin" | uniq)

# Additional PATH entries
{{- template "path-additions-nushell" . }}

# Snap binary path
{{- template "snap-path" . }}

# Cargo tools status check
{{- template "cargo-tools" . }}

# fnm (Node version manager) setup
{{- template "fnm-setup-nushell" . }}

# Custom user-defined paths
# Custom paths disabled temporarily