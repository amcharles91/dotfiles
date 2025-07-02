# Windows Development Tools Setup Script
# This script installs a comprehensive development environment on Windows
# Run with: .\setup-dev-tools.ps1

Write-Host "🚀 Windows Development Environment Setup - Extended Tools" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

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

# Check for winget
if (-not (Test-Command "winget")) {
    Write-Error "winget is not installed. Please install App Installer from Microsoft Store first."
    Write-Host "Visit: https://www.microsoft.com/store/productId/9NBLGGH4NNS1" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n✅ winget is available" -ForegroundColor Green

# Define package categories
$coreDevPackages = @(
    @{ID = "Microsoft.VisualStudioCode"; Name = "Visual Studio Code"},
    @{ID = "JetBrains.Toolbox"; Name = "JetBrains Toolbox"},
    @{ID = "Microsoft.PowerToys"; Name = "PowerToys"},
    @{ID = "Microsoft.WindowsTerminal"; Name = "Windows Terminal"},
    @{ID = "Git.Git"; Name = "Git"},
    @{ID = "TortoiseGit.TortoiseGit"; Name = "TortoiseGit"},
    @{ID = "PostgreSQL.pgAdmin"; Name = "pgAdmin"}
)

# Unreal Engine / Game Development packages
$gameDevPackages = @(
    @{ID = "Microsoft.VisualStudio.2022.Community"; Name = "Visual Studio 2022 Community"},
    @{ID = "EpicGames.EpicGamesLauncher"; Name = "Epic Games Launcher"},
    @{ID = "Kitware.CMake"; Name = "CMake"}
)

$languagePackages = @(
    @{ID = "Rustlang.Rust.MSVC"; Name = "Rust (MSVC)"},
    @{ID = "Python.Python.3.12"; Name = "Python 3.12"},
    @{ID = "GoLang.Go"; Name = "Go"},
    @{ID = "Microsoft.DotNet.SDK.8"; Name = ".NET SDK 8"}
)

$cliToolPackages = @(
    @{ID = "BurntSushi.ripgrep.MSVC"; Name = "ripgrep"},
    @{ID = "sharkdp.fd"; Name = "fd"},
    @{ID = "junegunn.fzf"; Name = "fzf"},
    @{ID = "Microsoft.PowerShell"; Name = "PowerShell 7"},
    @{ID = "gerardog.gsudo"; Name = "gsudo"}
)

$productivityPackages = @(
    @{ID = "7zip.7zip"; Name = "7-Zip"},
    @{ID = "voidtools.Everything"; Name = "Everything"},
    @{ID = "DevToys-app.DevToys"; Name = "DevToys"},
    @{ID = "Microsoft.Sysinternals.ProcessExplorer"; Name = "Process Explorer"},
    @{ID = "Files-Community.Files"; Name = "Files"},
    @{ID = "RevoUninstaller.RevoUninstaller"; Name = "Revo Uninstaller"}
)

$applicationPackages = @(
    @{ID = "AgileBits.1Password"; Name = "1Password"},
    @{ID = "Discord.Discord"; Name = "Discord"},
    @{ID = "Brave.Brave"; Name = "Brave Browser"},
    @{ID = "REALiX.HWiNFO"; Name = "HWiNFO"},
    @{ID = "TechPowerUp.GPU-Z"; Name = "GPU-Z"},
    @{ID = "Valve.Steam"; Name = "Steam"}
)

# Function to install packages
function Install-Packages {
    param(
        [Parameter(Mandatory=$true)]
        [Array]$Packages,
        [Parameter(Mandatory=$true)]
        [String]$CategoryName
    )
    
    Write-Host "`n📦 Installing $CategoryName..." -ForegroundColor Yellow
    
    foreach ($package in $Packages) {
        Write-Host "  Installing $($package.Name)..." -ForegroundColor Cyan
        
        # Check if already installed
        $installed = winget list --id $package.ID --exact | Select-String $package.ID
        
        if ($installed) {
            Write-Host "  ✅ $($package.Name) already installed" -ForegroundColor Green
        } else {
            try {
                winget install --id $package.ID -e --silent --accept-package-agreements --accept-source-agreements
                Write-Host "  ✅ $($package.Name) installed successfully" -ForegroundColor Green
            } catch {
                Write-Warning "  ❌ Failed to install $($package.Name): $_"
            }
        }
    }
}

# Main installation menu
Write-Host "`n🎯 Installation Options:" -ForegroundColor Yellow
Write-Host "1. Install Everything (Recommended)"
Write-Host "2. Custom Installation"
Write-Host "3. Exit"

$choice = Read-Host "`nSelect option (1-3)"

if ($choice -eq "3") {
    Write-Host "`nExiting..." -ForegroundColor Yellow
    exit 0
}

if ($choice -eq "1") {
    # Install everything
    Install-Packages -Packages $coreDevPackages -CategoryName "Core Development Tools"
    Install-Packages -Packages $gameDevPackages -CategoryName "Game Development Tools"
    Install-Packages -Packages $languagePackages -CategoryName "Programming Languages"
    Install-Packages -Packages $cliToolPackages -CategoryName "CLI Tools"
    Install-Packages -Packages $productivityPackages -CategoryName "Productivity Tools"
    Install-Packages -Packages $applicationPackages -CategoryName "Applications"
} elseif ($choice -eq "2") {
    # Custom installation
    Write-Host "`n📋 Select categories to install:" -ForegroundColor Yellow
    
    $categories = @(
        @{Name = "Core Development Tools"; Packages = $coreDevPackages; Install = $false},
        @{Name = "Game Development Tools"; Packages = $gameDevPackages; Install = $false},
        @{Name = "Programming Languages"; Packages = $languagePackages; Install = $false},
        @{Name = "CLI Tools"; Packages = $cliToolPackages; Install = $false},
        @{Name = "Productivity Tools"; Packages = $productivityPackages; Install = $false},
        @{Name = "Applications"; Packages = $applicationPackages; Install = $false}
    )
    
    for ($i = 0; $i -lt $categories.Count; $i++) {
        $response = Read-Host "$($i + 1). Install $($categories[$i].Name)? (Y/N)"
        if ($response -eq 'Y' -or $response -eq 'y') {
            $categories[$i].Install = $true
        }
    }
    
    # Install selected categories
    foreach ($category in $categories) {
        if ($category.Install) {
            Install-Packages -Packages $category.Packages -CategoryName $category.Name
        }
    }
}

# Cargo tools installation
Write-Host "`n🦀 Checking Rust/Cargo installation..." -ForegroundColor Yellow

if (Test-Command "cargo") {
    Write-Host "✅ Cargo is installed" -ForegroundColor Green
    
    Write-Host "`nInstalling cargo tools..." -ForegroundColor Yellow
    
    # Install cargo-binstall first
    if (-not (Test-Command "cargo-binstall")) {
        Write-Host "Installing cargo-binstall..." -ForegroundColor Cyan
        cargo install cargo-binstall
    }
    
    # Install cargo-update
    if (-not (Test-Command "cargo-install-update")) {
        Write-Host "Installing cargo-update..." -ForegroundColor Cyan
        cargo install cargo-update
    }
    
    # Install other tools via cargo-binstall
    $cargoTools = @("fnm", "eza", "tokei", "bottom")
    
    foreach ($tool in $cargoTools) {
        Write-Host "Installing $tool..." -ForegroundColor Cyan
        cargo binstall -y $tool
    }
    
    Write-Host "✅ Cargo tools installed" -ForegroundColor Green
} else {
    Write-Warning "Rust/Cargo not installed. Skipping cargo tools."
    Write-Host "Install Rust first, then run: cargo install cargo-binstall cargo-update" -ForegroundColor Yellow
    Write-Host "Then: cargo binstall -y fnm eza tokei bottom" -ForegroundColor Yellow
}

# Visual Studio Configuration for Unreal Engine
Write-Host "`n🎮 Visual Studio Configuration for Unreal Engine" -ForegroundColor Yellow
Write-Host "================================================" -ForegroundColor Yellow

if (Test-Command "code") {
    Write-Host "`n⚠️  IMPORTANT: Visual Studio 2022 Community was installed, but you need to add components for Unreal Engine:" -ForegroundColor Yellow
    Write-Host "`nRequired workloads and components:" -ForegroundColor Cyan
    Write-Host "1. Open Visual Studio Installer"
    Write-Host "2. Click 'Modify' on Visual Studio 2022 Community"
    Write-Host "3. Install these workloads:" -ForegroundColor Green
    Write-Host "   ✓ Game development with C++"
    Write-Host "   ✓ Desktop development with C++"
    Write-Host "   ✓ .NET desktop development (for tools)"
    Write-Host "`n4. In 'Individual components' tab, ensure these are selected:" -ForegroundColor Green
    Write-Host "   ✓ MSVC v143 - VS 2022 C++ x64/x86 build tools"
    Write-Host "   ✓ Windows 10 SDK (latest)"
    Write-Host "   ✓ .NET Framework 4.6.2 targeting pack"
    Write-Host "   ✓ .NET Framework 4.8 SDK"
    
    Write-Host "`nAlternatively, run this command to install Unreal Engine workloads:" -ForegroundColor Cyan
    Write-Host 'winget install Microsoft.VisualStudio.2022.Community --override "--add Microsoft.VisualStudio.Workload.NativeGame --add Microsoft.VisualStudio.Workload.NativeDesktop --add Microsoft.VisualStudio.Workload.ManagedDesktop --includeRecommended --passive"' -ForegroundColor White
}

# Summary
Write-Host "`n✨ Setup Complete!" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

Write-Host "`nInstalled tools summary:" -ForegroundColor Cyan

# Check what's actually installed
$checkTools = @(
    @{Command = "code"; Name = "VS Code"},
    @{Command = "git"; Name = "Git"},
    @{Command = "pwsh"; Name = "PowerShell 7"},
    @{Command = "python"; Name = "Python"},
    @{Command = "go"; Name = "Go"},
    @{Command = "cargo"; Name = "Rust/Cargo"},
    @{Command = "rg"; Name = "ripgrep"},
    @{Command = "fd"; Name = "fd"},
    @{Command = "fzf"; Name = "fzf"},
    @{Command = "gsudo"; Name = "gsudo"},
    @{Command = "fnm"; Name = "fnm"},
    @{Command = "eza"; Name = "eza"},
    @{Command = "tokei"; Name = "tokei"},
    @{Command = "btm"; Name = "bottom"}
)

foreach ($tool in $checkTools) {
    if (Test-Command $tool.Command) {
        Write-Host "  ✅ $($tool.Name)" -ForegroundColor Green
    }
}

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Restart your terminal for PATH changes to take effect"
Write-Host "2. Run 'winget upgrade' periodically to update packages"
Write-Host "3. Run 'cargo install-update -a' to update cargo packages"

Write-Host "`nPress any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")