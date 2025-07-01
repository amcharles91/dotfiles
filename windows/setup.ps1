# Windows Setup Script for Shells and Starship
# This script installs shells, Starship prompt, and JetBrainsMono Nerd Font on Windows

Write-Host "🚀 Windows Development Environment Setup" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "Some installations may require administrator privileges. Consider running as Administrator."
}

# Function to check if a command exists
function Test-Command {
    param($Command)
    try {
        if (Get-Command $Command -ErrorAction Stop) {
            return $true
        }
    } catch {
        return $false
    }
    return $false
}

# Install package managers if needed
Write-Host "`n📦 Checking package managers..." -ForegroundColor Yellow

# Check for winget
if (-not (Test-Command "winget")) {
    Write-Warning "winget not found. Please install App Installer from Microsoft Store."
    Write-Host "Alternatively, you can install via PowerShell:" -ForegroundColor Cyan
    Write-Host "Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe"
} else {
    Write-Host "✅ winget is available" -ForegroundColor Green
}

# Check for Scoop as alternative
if (-not (Test-Command "scoop")) {
    Write-Host "`nScoop not found. Would you like to install it? (Y/N)" -ForegroundColor Yellow
    $installScoop = Read-Host
    if ($installScoop -eq 'Y' -or $installScoop -eq 'y') {
        Write-Host "Installing Scoop..." -ForegroundColor Cyan
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
        scoop bucket add extras
        scoop bucket add nerd-fonts
    }
} else {
    Write-Host "✅ Scoop is available" -ForegroundColor Green
}

# Install shells
Write-Host "`n🐚 Installing shells..." -ForegroundColor Yellow

# Fish Shell
if (-not (Test-Command "fish")) {
    Write-Host "Installing Fish shell..." -ForegroundColor Cyan
    if (Test-Command "winget") {
        winget install --id Fisherman.Fish -e --silent --accept-package-agreements --accept-source-agreements
    } elseif (Test-Command "scoop") {
        scoop install fish
    } else {
        Write-Warning "Cannot install Fish shell - no package manager available"
    }
} else {
    Write-Host "✅ Fish shell already installed" -ForegroundColor Green
}

# Nushell
if (-not (Test-Command "nu")) {
    Write-Host "Installing Nushell..." -ForegroundColor Cyan
    if (Test-Command "winget") {
        winget install --id Nushell.Nushell -e --silent --accept-package-agreements --accept-source-agreements
    } elseif (Test-Command "scoop") {
        scoop install nu
    } else {
        Write-Warning "Cannot install Nushell - no package manager available"
    }
} else {
    Write-Host "✅ Nushell already installed" -ForegroundColor Green
}

# Install Starship
Write-Host "`n⭐ Installing Starship prompt..." -ForegroundColor Yellow
if (-not (Test-Command "starship")) {
    if (Test-Command "winget") {
        winget install --id Starship.Starship -e --silent --accept-package-agreements --accept-source-agreements
    } elseif (Test-Command "scoop") {
        scoop install starship
    } else {
        # Fallback to direct installation
        Write-Host "Installing Starship via installer script..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri https://starship.rs/install.ps1 -UseBasicParsing | Invoke-Expression
    }
} else {
    Write-Host "✅ Starship already installed" -ForegroundColor Green
}

# Install JetBrainsMono Nerd Font
Write-Host "`n🔤 Installing JetBrainsMono Nerd Font..." -ForegroundColor Yellow

if (Test-Command "scoop") {
    # Scoop method (easier)
    if (-not (scoop list | Select-String "JetBrainsMono-NF")) {
        scoop install JetBrainsMono-NF
    } else {
        Write-Host "✅ JetBrainsMono Nerd Font already installed" -ForegroundColor Green
    }
} else {
    # Manual download method
    $fontName = "JetBrainsMono"
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    $tempPath = "$env:TEMP\$fontName.zip"
    $extractPath = "$env:TEMP\$fontName"
    
    try {
        Write-Host "Downloading font..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $fontUrl -OutFile $tempPath
        
        Write-Host "Extracting font..." -ForegroundColor Cyan
        Expand-Archive -Path $tempPath -DestinationPath $extractPath -Force
        
        Write-Host "Installing font..." -ForegroundColor Cyan
        $fonts = Get-ChildItem -Path $extractPath -Include "*.ttf", "*.otf" -Recurse
        
        foreach ($font in $fonts) {
            $fontDestination = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$($font.Name)"
            Copy-Item -Path $font.FullName -Destination $fontDestination -Force
            
            # Register font in registry
            $fontRegistryPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
            $fontName = $font.BaseName
            New-ItemProperty -Path $fontRegistryPath -Name $fontName -Value $fontDestination -PropertyType String -Force | Out-Null
        }
        
        # Clean up
        Remove-Item -Path $tempPath -Force
        Remove-Item -Path $extractPath -Recurse -Force
        
        Write-Host "✅ JetBrainsMono Nerd Font installed" -ForegroundColor Green
    } catch {
        Write-Warning "Failed to install font: $_"
    }
}

# Configure Windows Terminal (if installed)
Write-Host "`n⚙️  Configuring Windows Terminal..." -ForegroundColor Yellow

$wtSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$wtPreviewSettingsPath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\LocalState\settings.json"

if ((Test-Path $wtSettingsPath) -or (Test-Path $wtPreviewSettingsPath)) {
    Write-Host "Windows Terminal detected." -ForegroundColor Green
    Write-Host "Please manually update your Windows Terminal settings to use 'JetBrainsMono Nerd Font' as the font." -ForegroundColor Yellow
    Write-Host "You can also copy the settings from: $PSScriptRoot\..\windows-terminal\settings.json" -ForegroundColor Cyan
} else {
    Write-Warning "Windows Terminal not found. Install it from Microsoft Store for the best experience."
}

# Configure PowerShell profile for Starship
Write-Host "`n📝 Configuring PowerShell profile..." -ForegroundColor Yellow

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

$starshipInit = @"
# Initialize Starship prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}
"@

if (Test-Path $PROFILE) {
    $profileContent = Get-Content $PROFILE -Raw
    if ($profileContent -notmatch "starship init") {
        Add-Content -Path $PROFILE -Value "`n$starshipInit"
        Write-Host "✅ Added Starship to PowerShell profile" -ForegroundColor Green
    } else {
        Write-Host "✅ Starship already configured in PowerShell profile" -ForegroundColor Green
    }
} else {
    Set-Content -Path $PROFILE -Value $starshipInit
    Write-Host "✅ Created PowerShell profile with Starship" -ForegroundColor Green
}

# Summary
Write-Host "`n✨ Setup Complete!" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

Write-Host "`nInstalled components:" -ForegroundColor Cyan
if (Test-Command "fish") { Write-Host "  ✅ Fish shell" -ForegroundColor Green }
if (Test-Command "nu") { Write-Host "  ✅ Nushell" -ForegroundColor Green }
if (Test-Command "starship") { Write-Host "  ✅ Starship prompt" -ForegroundColor Green }
Write-Host "  ✅ JetBrainsMono Nerd Font (may require restart)" -ForegroundColor Green

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Restart your terminal for all changes to take effect"
Write-Host "2. Update Windows Terminal to use 'JetBrainsMono Nerd Font'"
Write-Host "3. Run WSL and use 'chezmoi init --apply <your-repo>' to set up Linux side"

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")