# PowerShell script to install Git on Windows 11 Pro

# Define the Git installer URL
$gitInstallerUrl = "https://github.com/git-for-windows/git/releases/latest/download/Git-2.40.1-64-bit.exe"

# Define the path where the Git installer will be downloaded
$gitInstallerPath = "$env:TEMP\Git-Installer.exe"

# Download the Git installer
Invoke-WebRequest -Uri $gitInstallerUrl -OutFile $gitInstallerPath

# Run the Git installer silently
Start-Process -FilePath $gitInstallerPath -ArgumentList "/SILENT" -Wait

# Remove the Git installer after installation
Remove-Item -Path $gitInstallerPath -Force

# Verify the installation
git --version
