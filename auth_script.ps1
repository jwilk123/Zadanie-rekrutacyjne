$clientId = $env:AZURE_CLIENT_ID
$tenantId = $env:AZURE_TENANT_ID
$clientSecret = $env:AZURE_CLIENT_SECRET

$secureSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)
Connect-AzAccount -Credential $credential -Tenant $tenantId -ServicePrincipal 

$resourceGroupName = "rg-rekrutacja-patel"
$storageAccountName = "teststorage7925"
$location = "westeurope"

Get-AzResourceGroup -Name $resourceGroupName -ErrorAction Stop
New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -Location $location -SkuName "Standard_LRS" -Kind "StorageV2"

$storage = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
Write-Host "utworzono $($storage.StorageAccountName)"