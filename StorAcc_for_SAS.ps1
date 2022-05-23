Connect-AzAccount -AccountId "fopskt@gmail.com"
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
New-AzStorageContainer `
  -Name templates `
  -Permission Off
Set-AzStorageBlobContent `
  -Container templates `
  -File .\main.json
Set-AzStorageBlobContent `
  -Container templates `
  -File .\parametrs.json
$templateuri = New-AzStorageBlobSASToken `
-Container templates `
-Blob main.json `
-Permission r `
-ExpiryTime (Get-Date).AddHours(2.0) -FullUri
$parameteruri = New-AzStorageBlobSASToken `
-Container templates `
-Blob parametrs.json `
-Permission r `
-ExpiryTime (Get-Date).AddHours(2.0) -FullUri
New-AzResourceGroupDeployment `
-ResourceGroupName ExampleGroup1 `
-TemplateUri $templateuri `
-TemplateParameterUri $parameteruri