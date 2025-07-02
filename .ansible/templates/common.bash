# This file is managed by Ansible. DO NOT EDIT.
# Source this file in your .bashrc

# Prepend a path to PATH, but only if it exists and is not already in PATH
prepend_path() {
    # Return if the path is not a directory
    [ -d "$1" ] || return
    
    # Return if the path is already in PATH
    case ":$PATH:" in
        *":$1:"*) return;;
    esac
    
    # Prepend the path
    PATH="$1${PATH:+":$PATH"}"
}

# Add custom paths
{% for path in path_entries %}
prepend_path "{{ path | replace('$HOME', '$HOME') }}"
{% endfor %}

# Clean up the helper function
unset -f prepend_path
export PATH

# Rust/Cargo
export CARGO_HOME="$HOME/.cargo"

# fnm (Fast Node Manager)
if command -v fnm &> /dev/null; then
    export FNM_DIR="$HOME/.local/share/fnm"
    eval "$(fnm env --use-on-cd)"
fi

# Starship prompt
if command -v starship &> /dev/null; then
    export STARSHIP_SHELL="bash"
    eval "$(starship init bash)"
fi