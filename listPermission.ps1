$tenant = ""
$fileToExport = "c:\temp\rolesAz.csv"

Connect-AzAccount -tenant $tenant -AuthScope MicrosoftGraphEndpointResourceId

$subs = Get-AzSubscription -TenantId $tenant
$roleExport = @()
foreach($sub in $subs){
    $sub | Select-AzSubscription
    $rolesAssignments = Get-AzRoleAssignment | Select-Object DisplayName, RoleDefinitionName, Scope,ObjectType
    foreach($r in $rolesAssignments){
        $roleExport += [PSCustomObject]@{
            DisplayName = $r.DisplayName
            Role = $r.RoleDefinitionName
            Scope = $r.Scope
            Type = $r.ObjectType
            SubscriptionName = $sub.Name
            SubscriptionID = $sub.Id
        }
    }
}

$roleExport | Export-Csv -Path $fileToExport