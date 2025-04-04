# Check if the current session is running with administrator privileges
$currentUser = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent()))
$isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-Not $isAdmin) {
    # Re-launch the script with administrator privileges
    $script = [System.Diagnostics.Process]::Start("powershell.exe", "-Command Start-Process PowerShell -Verb RunAs")
    exit
} else {
    Write-Host "PowerShell is running with elevated privileges."
    # You can add your elevated commands here
}
