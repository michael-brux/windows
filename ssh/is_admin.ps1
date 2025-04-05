# Check if the current session is elevated
$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if ($isElevated) {
    Write-Output "The current session is running with administrator privileges."
} else {
    Write-Output "The current session is NOT running with administrator privileges."
}

# Check if the user is a member of the Administrators group
$isAdminGroupMember = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("S-1-5-32-544") # SID for Administrators group

if ($isAdminGroupMember) {
    Write-Output "The current user is a member of the Administrators group and can elevate."
} else {
    Write-Output "The current user is NOT a member of the Administrators group."
}

# Get the current user's identity
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()

# Get all group memberships
$groupMemberships = $currentUser.Groups | ForEach-Object {
    $_.Translate([Security.Principal.NTAccount]).Value
}

# Output all group memberships
Write-Output "The current user is a member of the following groups:"
$groupMemberships | ForEach-Object { Write-Output "- $_" }