# Get the current Windows version details
$osVersion = [System.Environment]::OSVersion.Version
$windowsVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
$currentBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
$releaseId = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId

# Print the Windows version details
Write-Output "OS Version: $osVersion"
Write-Output "Current Windows Version: $windowsVersion"
Write-Output "Build Number: $currentBuild"
Write-Output "Release ID: $releaseId"

# Additional check for Windows 11
if ($currentBuild -ge 22000) {
    Write-Output "This system is running Windows 11."
} else {
    Write-Output "This system is running Windows 10 or earlier."
}