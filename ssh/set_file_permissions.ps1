# Define the path to the authorized_keys file
$authorizedKeysPath = "$env:USERPROFILE\.ssh\authorized_keys"

# Check if the authorized_keys file exists
if (Test-Path -Path $authorizedKeysPath) {
    # Get the current ACL (Access Control List) of the file
    $acl = Get-Acl -Path $authorizedKeysPath

    # Remove all existing ACL entries
    $acl.Access | ForEach-Object { $acl.RemoveAccessRule($_) }

    # Set full control for the current user
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $fullControlRule = New-Object System.Security.AccessControl.FileSystemAccessRule($currentUser, "FullControl", "Allow")
    $acl.AddAccessRule($fullControlRule)

    # Optionally, you can add read access for the Administrators group without denying write access
    $administrators = "BUILTIN\Administrators"
    $readRule = New-Object System.Security.AccessControl.FileSystemAccessRule($administrators, "Read", "Allow")
    $acl.AddAccessRule($readRule)

    # Set the owner to the current user
    $acl.SetOwner([System.Security.Principal.NTAccount]$currentUser)

    # Apply the modified ACL to the file
    Set-Acl -Path $authorizedKeysPath -AclObject $acl

    Write-Output "Permissions and ownership for the authorized_keys file have been set successfully."
} else {
    Write-Output "The authorized_keys file does not exist at the specified path: $authorizedKeysPath"
}
