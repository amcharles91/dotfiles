# This file is managed by Ansible. DO NOT EDIT.
# Source this file in your env.nu

# Add paths to PATH
$env.PATH = ($env.PATH | split row (char esep) | 
{% for path in path_entries %}
{% if '$HOME' in path %}
    prepend $"($env.HOME){{ path.replace('$HOME', '') }}" |
{% else %}
    prepend "{{ path }}" |
{% endif %}
{% endfor %}
    uniq)

# Rust/Cargo
$env.CARGO_HOME = $"($env.HOME)/.cargo"

# fnm (Fast Node Manager)
if (which fnm | length) > 0 {
    $env.FNM_DIR = $"($env.HOME)/.local/share/fnm"
    # Load fnm environment
    load-env (fnm env --shell bash | lines | str replace 'export ' '' | str replace -a '"' '' | split column "=" | rename name value | where name != "FNM_ARCH" and name != "PATH" | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value })
    # Add fnm to PATH
    $env.PATH = ($env.PATH | split row (char esep) | prepend $"($env.FNM_MULTISHELL_PATH)/bin" | uniq)
}

# Note: Starship is configured in config.nu, not env.nu