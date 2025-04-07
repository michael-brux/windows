# PowerShell 7 Example Script for Windows 11 Pro

# This script demonstrates various common PowerShell 7 tasks on Windows 11 Pro.
# It includes examples of:
#   - Basic output and variables
#   - Working with files and directories
#   - Running commands and capturing output
#   - Conditional logic (if/else)
#   - Loops (foreach)
#   - Functions
#   - Error handling (try/catch)
#   - Working with JSON
#   - Using modules

# --- Basic Output and Variables ---

Write-Host "Hello from PowerShell 7 on Windows 11 Pro!" -ForegroundColor Green

$userName = $env:USERNAME
Write-Host "Current user: $userName"

$currentDate = Get-Date
Write-Host "Current date and time: $currentDate"

# --- Working with Files and Directories ---

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "Script directory: $scriptDirectory"

$testDirectory = Join-Path -Path $scriptDirectory -ChildPath "TestDirectory"

# Create a directory if it doesn't exist
if (!(Test-Path -Path $testDirectory)) {
    New-Item -ItemType Directory -Path $testDirectory
    Write-Host "Created directory: $testDirectory"
} else {
    Write-Host "Directory already exists: $testDirectory"
}

$testFile = Join-Path -Path $testDirectory -ChildPath "TestFile.txt"

# Create a file and write some content
"This is a test file." | Out-File -FilePath $testFile -Encoding UTF8
Write-Host "Created file: $testFile"

# Read the content of the file
$fileContent = Get-Content -Path $testFile
Write-Host "File content:"
Write-Host $fileContent

# --- Running Commands and Capturing Output ---

$systemInfo = Get-ComputerInfo
Write-Host "Operating System: $($systemInfo.OsName)"
Write-Host "OS Version: $($systemInfo.OsVersion)"

$ipConfig = ipconfig
Write-Host "IP Configuration:"
Write-Host $ipConfig

# --- Conditional Logic (if/else) ---

if ($systemInfo.OsName -like "*Windows 11*") {
    Write-Host "Running on Windows 11"
} else {
    Write-Host "Not running on Windows 11"
}

# --- Loops (foreach) ---

$numbers = 1, 2, 3, 4, 5
Write-Host "Numbers:"
foreach ($number in $numbers) {
    Write-Host $number
}

# --- Functions ---

function Get-SystemUptime {
    $uptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    $uptime = New-TimeSpan -Start $uptime -End (Get-Date)
    return "System Uptime: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes"
}

Write-Host (Get-SystemUptime)

# --- Error Handling (try/catch) ---

try {
    # Attempt to access a non-existent file
    Get-Content -Path "NonExistentFile.txt" -ErrorAction Stop
} catch {
    Write-Error "An error occurred: $($_.Exception.Message)"
}

# --- Working with JSON ---

$jsonData = @{
    Name = "Example"
    Version = "1.0"
    Description = "A sample JSON object"
} | ConvertTo-Json

Write-Host "JSON Data:"
Write-Host $jsonData

$jsonObj = ConvertFrom-Json -InputObject $jsonData
Write-Host "Name from JSON: $($jsonObj.Name)"

# --- Using Modules ---
# Example: Get-NetAdapter is part of the NetAdapter module.
try {
    Import-Module -Name NetAdapter -ErrorAction Stop
    $netAdapters = Get-NetAdapter
    Write-Host "Network Adapters:"
    $netAdapters | Format-Table -AutoSize
}
catch {
    Write-Error "Error importing NetAdapter module: $($_.Exception.Message)"
}

Write-Host "Script completed." -ForegroundColor Green
