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
    let starship_path = ($nu.data-dir | path join "vendor/autoload/starship.nu")
    let vendor_dir = ($nu.data-dir | path join "vendor/autoload")
    
    # Create vendor autoload directory if it doesn't exist
    if not ($vendor_dir | path exists) {
        mkdir $vendor_dir
    }
    
    # Generate starship init file if it doesn't exist
    if not ($starship_path | path exists) {
        starship init nu | save -f $starship_path
    }
    
    # Source it
    source $starship_path
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
