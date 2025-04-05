# show product key

# Check for elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "This script requires administrator privileges to run."
    Write-Output "Please restart PowerShell as an administrator and try again."
    exit
}

wmic path softwarelicensingservice get OA3xOriginalProductKey