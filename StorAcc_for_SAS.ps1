Connect-AzAccount
Select-AzSubscription "23f5f8a4-4a06-4dce-92e7-6b980f7ad0b8"
New-AzResourceGroup `
  -Name ExampleGroup1 `
  -Location "East US"
New-AzStorageAccount `
  -ResourceGroupName ExampleGroup1 `
  -Name depp00001 `
  -Type Standard_LRS `
  -Location "East US"
Set-AzCurrentStorageAccount `
  -ResourceGroupName ExampleGroup1 `
  -Name depp00001
Start-Sleep -Seconds 120
New-AzStorageContainer `
  -Name templates `
  -Permission Off
Set-AzStorageBlobContent `
  -Container templates `
  -File .\main.json
Set-AzStorageBlobContent `
  -Container templates `
  -File .\parametrs.json
Set-AzStorageBlobContent `
  -Container templates `
  -File .\linked\storage_account.json
Set-AzStorageBlobContent `
  -Container templates `
  -File .\linked\virtual_network.json
$templateuri = (Get-AzStorageBlob -Container templates -Blob main.json).ICloudBlob.uri.AbsoluteUri
$parameteruri = (Get-AzStorageBlob -Container templates -Blob parametrs.json).ICloudBlob.uri.AbsoluteUri
$token = New-AzStorageContainerSASToken -Name templates -Permission r -ExpiryTime (Get-Date).AddMinutes(30.0)
New-AzResourceGroupDeployment -ResourceGroupName ExampleGroup1 -TemplateUri ($templateuri + $token) -TemplateParameterUri ($parameteruri + $token) -containerSasToken $token
