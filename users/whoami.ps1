# Run whoami commands with /fo csv and capture the output
$whoamiUserOutput = whoami /user /fo csv
$whoamiGroupOutput = whoami /groups /fo csv
$whoamiPrivOutput = whoami /priv /fo csv

# Convert the CSV outputs into objects for easier handling
$parsedUserOutput = $whoamiUserOutput | ConvertFrom-Csv
$parsedGroupOutput = $whoamiGroupOutput | ConvertFrom-Csv
$parsedPrivOutput = $whoamiPrivOutput | ConvertFrom-Csv

# Output the parsed results
Write-Output "Parsed whoami /user /fo csv result:"
$parsedUserOutput | ForEach-Object { Write-Output $_ }
$whoamiUserOutput  

Write-Output "`nParsed whoami /groups /fo csv result:"
$parsedGroupOutput | ForEach-Object { Write-Output $_ }
$whoamiGroupOutput

Write-Output "`nParsed whoami /priv /fo csv result:"
$parsedPrivOutput | ForEach-Object { Write-Output $_ }
$whoamiPrivOutput