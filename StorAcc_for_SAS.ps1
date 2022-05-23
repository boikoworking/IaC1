Connect-AzAccount -AccountId "fopskt@gmail.com"
Select-AzSubscription "23f5f8a4-4a06-4dce-92e7-6b980f7ad0b8"
New-AzResourceGroup `
  -Name ExampleGroup `
  -Location "East US"
New-AzStorageAccount `
  -ResourceGroupName ExampleGroup `
  -Name depp090909 `
  -Type Standard_LRS `
  -Location "East US"
Set-AzCurrentStorageAccount `
  -ResourceGroupName ExampleGroup `
  -Name depp090909
New-AzStorageContainer `
  -Name template `
  -Permission Off
  Set-AzStorageBlobContent `
  -Container templates `
  -File .\main.json
  Set-AzStorageBlobContent `
  -Container template `
  -File .\parametrs.json
  # get the URI with the SAS token
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
# provide URI with SAS token during deployment
New-AzResourceGroupDeployment `
-ResourceGroupName ExampleGroup `
-TemplateUri $templateuri `
-TemplateParameterUri $parameteruri