# This file is managed by Ansible. DO NOT EDIT.
# Source this file in your env.nu

# Define custom paths to add
let custom_paths = [
{% for path in path_entries %}
{% if '$HOME' in path %}
    $"($env.HOME){{ path.replace('$HOME', '') }}",
{% else %}
    "{{ path }}",
{% endif %}
{% endfor %}
]

# Ensure PATH exists as a string (Nushell may start with PATH as list or missing)
let current_path = if ("PATH" in $env) {
    if ($env.PATH | describe) == "string" {
        $env.PATH | split row (char esep)
    } else {
        $env.PATH
    }
} else {
    []
}

# Prepend custom paths and remove duplicates
$env.PATH = ($custom_paths | append $current_path | uniq | str join (char esep))

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