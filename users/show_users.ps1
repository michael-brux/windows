# List all enabled local users
$localUsers = Get-LocalUser | Where-Object { $_.Enabled -eq $true }

# Output the list of enabled users
Write-Output "List of enabled local users:"
$localUsers | ForEach-Object {
    Write-Output "- Username: $($_.Name)"
}