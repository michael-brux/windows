# Script to install OpenSSH client and server on Windows

# Check for administrative privileges
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    # Re-launch the script with elevated privileges
    Start-Process powershell "-File $PSCommandPath" -Verb RunAs
    Exit
}

# Install OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start and set OpenSSH Server to start automatically
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the installation
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
