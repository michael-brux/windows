# Get the current user's identity
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()

# Get all group memberships
$groupMemberships = $currentUser.Groups | ForEach-Object {
    $_.Translate([Security.Principal.NTAccount]).Value
}

# Output all group memberships
Write-Output "The current user is a member of the following groups (from token):"
$groupMemberships | ForEach-Object { Write-Output "- $_" }

# Get local group memberships
Write-Output "`nThe current user is explicitly a member of the following local groups:"
Get-LocalGroup | ForEach-Object {
    $groupName = $_.Name
    $members = Get-LocalGroupMember -Group $groupName | Where-Object { $_.Name -eq "$env:COMPUTERNAME\$($env:USERNAME)" }
    if ($members) {
        Write-Output "- $groupName"
    }
}