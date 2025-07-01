# This file is managed by Ansible. DO NOT EDIT.
# Source this file in your .bashrc

# Add paths if not already present
for p in {{ path_entries | join(' ') }}; do
    # Safe variable expansion without eval
    p="${p/#\~/$HOME}"     # Replace ~ with $HOME
    p="${p/#\$HOME/$HOME}" # Expand $HOME variable
    [[ ":$PATH:" != *":$p:"* ]] && PATH="$p:$PATH"
done
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
    eval "$(starship init bash)"
fi