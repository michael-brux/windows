# Get Computer Info


$computerInfo = Get-ComputerInfo

# Extract relevant details
$WindowsVersion = $computerInfo.WindowsProductName
$installDate = $computerInfo.WindowsInstallDateFromRegistry
$owner = $computerInfo.WindowsRegisteredOwner
$uptime = $computerInfo.OsUptime
$manufacturer = $computerInfo.CsManufacturer
$family = $computerInfo.CsSystemFamily
$model = $computerInfo.CsModel
$type = $computerInfo.CsSystemType

# Extract processor name and memory size
$processorName = $computerInfo.CsProcessors  # Get the first processor name
$totalMemoryGB = [math]::Round($computerInfo.CsTotalPhysicalMemory / 1GB, 2)  # Convert memory to GB


Write-Output "Windows Version: $WindowsVersion"
Write-Output "Install Date: $installDate"
Write-Output "Windows Registered Owner: $owner"
Write-Output "Uptime: $uptime"

Write-Output "Manufacturer: $manufacturer"
Write-Output "System Family: $family"
Write-Output "Model: $model"
Write-Output "System Type: $type"

Write-Output "Processor Name: $processorName"
Write-Output "Total Memory: $totalMemoryGB GB"