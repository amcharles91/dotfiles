# This file is managed by Ansible. DO NOT EDIT.
# Source this file in your config.fish

# Add paths
{% for path in path_entries %}
fish_add_path -p {{ path }}
{% endfor %}

# Rust/Cargo
set -gx CARGO_HOME "$HOME/.cargo"

# fnm (Fast Node Manager)
if command -sq fnm
    set -gx FNM_DIR "$HOME/.local/share/fnm"
    fnm env --use-on-cd | source
end

# Starship prompt
if status is-interactive
    and command -sq starship
    set -gx STARSHIP_SHELL "fish"
    starship init fish | source
end