# Fish shell configuration

# Add ~/.local/bin to PATH if not already present
fish_add_path -p $HOME/.local/bin

# Additional PATH entries
{{- template "path-additions-fish" . }}

{{- template "nvm-setup-fish" . }}

# Custom user-defined paths
{{- template "custom-paths-fish" . }}

# Initialize Starship
if status is-interactive
    starship init fish | source
end
