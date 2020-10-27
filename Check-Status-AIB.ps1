$managementEp = $currentAzureContext.Environment.ResourceManagerUrl
$imageResourceGroup="WVD-RGP-ImageBuilder"
$imageTemplateName="WVD-AIB-20201023.10"


### Step 1: Update context
$currentAzureContext = Get-AzContext

### Step 2: Get instance profile
$azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
$profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azureRmProfile)
    
Write-Verbose ("Tenant: {0}" -f  $currentAzureContext.Subscription.Name)
 
### Step 4: Get token  
$token = $profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)
$accessToken=$token.AccessToken

$urlBuildStatus = [System.String]::Format("{0}subscriptions/{1}/resourceGroups/$imageResourceGroup/providers/Microsoft.VirtualMachineImages/imageTemplates/{2}?api-version=2019-05-01-preview", $managementEp, $currentAzureContext.Subscription.Id,$imageTemplateName)

$buildStatusResult = Invoke-WebRequest -Method GET  -Uri $urlBuildStatus -UseBasicParsing -Headers  @{"Authorization"= ("Bearer " + $accessToken)} -ContentType application/json 
$buildJsonStatus =$buildStatusResult.Content
$buildJsonStatus

$managementEp = $currentAzureContext.Environment.ResourceManagerUrl
$urlRunOutputStatus = [System.String]::Format("{0}subscriptions/{1}/resourceGroups/$imageResourceGroup/providers/Microsoft.VirtualMachineImages/imageTemplates/$imageTemplateName/runOutputs/{2}?api-version=2019-05-01-preview", $managementEp, $currentAzureContext.Subscription.Id, $runOutputName)

$runOutStatusResult = Invoke-WebRequest -Method GET  -Uri $urlRunOutputStatus -UseBasicParsing -Headers  @{"Authorization"= ("Bearer " + $accessToken)} -ContentType application/json 
$runOutJsonStatus =$runOutStatusResult.Content
$runOutJsonStatus