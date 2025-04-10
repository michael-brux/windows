# Check if the current session is running with administrator privileges
$currentUser = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()))
$isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Determine the PowerShell executable to use
$pwshPath = "pwsh" # Default to PowerShell Core (PowerShell 7)
if (-Not (Get-Command $pwshPath -ErrorAction SilentlyContinue)) {
    $pwshPath = "powershell.exe" # Fallback to Windows PowerShell
}

if (-Not $isAdmin) {
    # Re-launch the script with administrator privileges in Windows Terminal
    $script = [System.Diagnostics.Process]::Start("wt.exe", "powershell -Command Start-Process $pwshPath -ArgumentList '-File', '$(Get-Command $MyInvocation.MyCommand.Definition).Path' -Verb RunAs")
    exit
} else {
    Write-Host "PowerShell is running with elevated privileges."
    # You can add your elevated commands here
}
