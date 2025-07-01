# Fish shell configuration

# Add ~/.local/bin to PATH if not already present
fish_add_path -p $HOME/.local/bin

# Additional PATH entries
{{- template "path-additions-fish" . }}

# Snap binary path
{{- template "snap-path-simple" . }}

# Rust/Cargo setup (with optional installation)
{{- template "rust-setup" . }}

# Cargo tools
{{- template "cargo-tools-simple" . }}

# fnm (Node version manager) setup
{{- template "fnm-setup-fish" . }}

# Custom user-defined paths
# Custom paths disabled temporarily

# Initialize Starship
if status is-interactive
    starship init fish | source
end
