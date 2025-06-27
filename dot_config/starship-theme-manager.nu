# Starship Theme Manager for Nushell (Cross-platform)
# Add this to your config.nu file

# Get the config directory based on OS
def get-starship-config-dir [] {
    # Get home directory based on OS
    let home = if $nu.os-info.name == "windows" {
        $env.USERPROFILE
    } else {
        $env.HOME
    }
    
    # First check if .config exists in home directory
    let home_config = ($home | path join ".config")
    if ($home_config | path exists) {
        return $home_config
    }
    
    # If on Windows and .config doesn't exist, check AppData
    if $nu.os-info.name == "windows" {
        let appdata_local = ($env.LOCALAPPDATA? | default ($env.APPDATA | path join ".." "Local" | path expand))
        if ($appdata_local | path exists) {
            return $appdata_local
        }
    }
    
    # Default to home/.config (create if needed)
    return $home_config
}

# Get full path to starship config
def get-starship-path [filename: string = "starship.toml"] {
    let config_dir = (get-starship-config-dir)
    return ($config_dir | path join $filename)
}

# List available themes
def "starship themes" [] {
    print "Available Starship themes:"
    let config_dir = (get-starship-config-dir)
    
    try {
        let files = (ls $config_dir 
            | where {|it| ($it.name | str contains "starship-") and ($it.name | str ends-with ".toml")}
            | get name)
        
        if ($files | is-empty) {
            print "  No theme files found"
            print $"  Looking in: ($config_dir)"
        } else {
            $files
            | each { |it| $it | path basename | str replace 'starship-' '' | str replace '.toml' '' }
            | each { |theme| print $"  • ($theme)" }
        }
    } catch { |e|
        print $"  Error: ($e.msg)"
        print $"  Directory: ($config_dir)"
        print "  Run 'starship where' for more info"
    }
}

# Switch theme
def "starship theme" [theme?: string] {
    if ($theme == null) {
        starship themes
        return
    }
    
    let theme_file = (get-starship-path $"starship-($theme).toml")
    let target_file = (get-starship-path)
    
    if not ($theme_file | path exists) {
        print $"Error: Theme '($theme)' not found!"
        starship themes
        return
    }
    
    cp $theme_file $target_file
    print $"✓ Switched to '($theme)' theme!"
    print "Restart your terminal or type 'exec nu' to see changes"
}

# Quick theme switcher (shorter alias)
def st [theme?: string] {
    starship theme $theme
}

# Backup current theme
def "starship backup" [name?: string] {
    let backup_name = if ($name == null) {
        let timestamp = (date now | format date "%Y%m%d_%H%M%S")
        $"backup_($timestamp)"
    } else {
        $name
    }
    
    let source = (get-starship-path)
    let target = (get-starship-path $"starship-($backup_name).toml")
    
    cp $source $target
    print $"✓ Backed up current theme as '($backup_name)'"
}

# Preview a theme (shows what it would look like)
def "starship preview" [theme: string] {
    print $"Preview of '($theme)' theme:"
    print "─────────────────────────────"
    
    let config_path = (get-starship-path)
    let theme_path = (get-starship-path $"starship-($theme).toml")
    
    # Temporarily switch and show prompt
    let original = (open $config_path)
    cp $theme_path $config_path
    
    # Show a fake prompt preview
    print "andre@laptop ~/projects/app  main [!?]  20.1 【2.5s】【14:23】✓"
    print "▶ (This is how your prompt would look)"
    
    # Restore original
    $original | save -f $config_path
}

# Reset to default
def "starship reset" [] {
    let backup_path = (get-starship-path "starship-original-backup.toml")
    let config_path = (get-starship-path)
    
    if ($backup_path | path exists) {
        cp $backup_path $config_path
        print "✓ Reset to original theme"
    } else {
        print "Error: No original backup found"
    }
}

# Show current config location
def "starship where" [] {
    let config_dir = (get-starship-config-dir)
    print $"Starship config directory: ($config_dir)"
    print $"Current config: (get-starship-path)"
    
    print "\nTheme files found:"
    try {
        ls $config_dir
        | where {|it| ($it.name | str contains "starship-") and ($it.name | str ends-with ".toml")}
        | get name
        | each { |f| print $"  • ($f)" }
    } catch {
        print "  No theme files found in current directory"
    }
    
    if $nu.os-info.name == "windows" {
        print "\nOn Windows, configs can also be in:"
        print $"  • ($env.USERPROFILE)\\.config"
        print $"  • ($env.LOCALAPPDATA? | default 'Not set')"
        print $"  • ($env.APPDATA)\\..\\Local"
    }
}

# Alternative simple listing (for debugging)
def "st list" [] {
    print "Direct listing of theme files:"
    ls ~/.config/starship-*.toml
    | get name
    | path basename
    | str replace 'starship-' ''
    | str replace '.toml' ''
    | each { |theme| print $"  • ($theme)" }
}

# Debug function to test file listing
def "st debug" [] {
    print "Testing different approaches:"
    print "\n1. Using ls with full path:"
    try {
        ls ~/.config/starship-*.toml | select name | print
    } catch { |e|
        print $"  Error: ($e.msg)"
    }
    
    print "\n2. Using ls with directory + filter:"
    try {
        ls ~/.config | where {|it| $it.name =~ 'starship-.*\.toml'} | select name | print
    } catch { |e|
        print $"  Error: ($e.msg)"
    }
}

# Simplest possible version
def "st simple" [] {
    print "Available themes:"
    ls ~/.config
    | where {|it| ($it.name | str contains "starship-") and ($it.name | str ends-with ".toml")}
    | get name
    | path basename
    | str replace 'starship-' ''
    | str replace '.toml' ''
    | each {|theme| print $"  • ($theme)"}
}