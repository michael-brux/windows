# Define the function to install Visual Studio Code
function Install-VSCode {
    Write-Host "Downloading Visual Studio Code..."
    $installerPath = "$env:TEMP\vscode_installer.exe"
    Invoke-WebRequest -Uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" -OutFile $installerPath

    Write-Host "Installing Visual Studio Code..."
    Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait

    # Clean up
    Remove-Item -Path $installerPath
}

# Define the function to install Extensions
function Install-VSCodeExtensions {
    Write-Host "Installing Visual Studio Code Extensions..."

    # Install GitHub Extension
    code --install-extension GitHub.github-vscode-theme

    # Install PowerShell Extension
    code --install-extension ms-vscode.powershell
}

# Check if Visual Studio Code is already installed
if (-not (Get-Command "code" -ErrorAction SilentlyContinue)) {
    Install-VSCode
} else {
    Write-Host "Visual Studio Code is already installed."
}

# Install the required extensions
Install-VSCodeExtensions

Write-Host "Visual Studio Code installation and extension setup complete."
