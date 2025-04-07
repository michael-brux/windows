function showVbscriptEnabled { 
    param(
        [switch]$Verbose
    )

    $vbscriptCapability = Get-WindowsCapability -online | Where-Object { $_.Name -like '*VBSCRIPT*' }
    if ($Verbose) { $vbscriptCapability }
    if ($vbscriptCapability.State -eq "NotPresent") {
        return $false 
    } elseif ($vbscriptCapability.State -eq "Installed") {
        return $true
    } else {
        throw "Unknown State: $($vbscriptCapability.State)"
    }
}

function enableVbscript {
    Get-WindowsCapability -online | Where-Object { $_.Name -like '*VBSCRIPT*' } | add-WindowsCapability -online
}

Write-Host "Checking VBScript Feature Status..."

$verbose = $MyInvocation.BoundParameters.ContainsKey('verbose')


if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an administrator."
    exit 1
}


if (showVbscriptEnabled -Verbose:$verbose) {
    Write-Host "VBScript is enabled."
} else {
    Write-Host "VBScript is not enabled."
    #Write-Host "Enabling VBScript..."
    #enableVbscript
}
