# Get the current Windows version details

# from CIM (Common Information Model)
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
$osBuild = $osInfo.BuildNumber
$osVersion = $osInfo.Version
$osWindowsVersion = $osInfo.Caption

# from System.Environment
$osEnvVersion = [System.Environment]::OSVersion.Version

# from Registry
$windowsRegistryVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName
$currentBuild = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild
$releaseId = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
$displayVersion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion

# Print the Windows version details
Write-Output "Windows Version: $osWindowsVersion"
Write-Output "OS Version: $osVersion"
Write-Output "Build Number: $osBuild"

if ($osBuild -ge 22000) {
    # Additional check for Windows 11
    Write-Output "This system is running Windows 11."
} else {
    Write-Output "This system is running Windows 10 or earlier."
}

Write-Output "OS Version: $osEnvVersion (from System.Environment)"

Write-Output "Current Windows Version: $windowsRegistryVersion (from Registry)"
if ($currentBuild -ne $osBuild) {
    # only show if the build number does not match
    Write-Output "Current Build Number: $currentBuild (not matching CIM)"
} 
Write-Output "Release ID: $releaseId"
Write-Output "Display Version: $displayVersion"









