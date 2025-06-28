# Nushell Configuration File
# ~/.config/nushell/config.nu

# Version check for compatibility
let nu_version = (version | get version)

# Basic configuration
$env.config = {
    show_banner: false
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "plaintext"
    }
}

# Initialize Starship prompt
# For Nushell 0.96+, source from the vendor autoload directory
# Note: You need to run this once after installation:
# mkdir ($nu.data-dir | path join "vendor/autoload")
# starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
if ((which starship | length) > 0) {
    source ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

# Optional: Add any custom commands or aliases here
# alias ll = ls -la
# alias gs = git status
