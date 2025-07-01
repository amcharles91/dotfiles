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
if ((which starship | length) > 0) {
    # Create vendor autoload directory if it doesn't exist
    mkdir ($nu.data-dir | path join "vendor/autoload")
    # Generate starship init file
    starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
    # Source it
    source ($nu.data-dir | path join "vendor/autoload/starship.nu")
}

# Common aliases
alias ll = ls -la
alias la = ls -a
alias l = ls
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git log --oneline
alias gd = git diff

# Custom commands
def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}
