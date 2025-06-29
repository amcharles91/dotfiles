# Fish shell configuration

# Add ~/.local/bin to PATH if not already present
fish_add_path -p $HOME/.local/bin

# Initialize Starship
if status is-interactive
    starship init fish | source
end
