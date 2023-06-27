function getKeyVaultSecrets([string]$subscriptionDet, [string]$keyVaultIdDet, [string]$keyVaultNameDet, [string] $keyVaultTeamName){
    Write-Output "Get KeyVault Secrets $keyVaultNameDet"
    $secrets = (az keyvault secret list --subscription "$subscriptionDet"  --vault-name "$keyVaultNameDet" --query  "[].{id:id, name:name}" --output tsv)
    $secretCount = $secrets.Count

    if($secretCount -gt 0){
        Write-Output "Processing $secretCount Key-Vault Secrets from $keyVaultNameDet"
        $secrets | foreach {
            $secret = $_
            $secretItemSplit = $secret -split "`t"
            $secretId = $secretItemSplit[0]
            $secretName = $secretItemSplit[1]
            Write-Output "$secretName;$secretId"
            $secretValue = (az keyvault secret show --subscription "$subscriptionDet" --id $secretId --query  "{value:value}" --output tsv)
            Write-Output "Secret Value: $secretValue"
            $newVaultName = "kvietv" + $keyVaultTeamName + "deveuweait1"
            $setSecret = (az keyvault secret set  --subscription "$subscriptionDet" --name $secretName --vault-name $newVaultName --value $secretValue)
        }
    }
}

function getKeyVaults([string]$subscription){
    $keyvaults = (az keyvault list --subscription "$subscription" --query  "[].{id:id, name:name} | [?contains(name,'kvietvblh')] | [?contains(name, 'aiteuwe1')]" --output tsv)

    $keyvaults | foreach {
        $keyvault = $_
        Write-Output "Processing Key Vault $keyvault"
        $keyvaultItemSlit = $keyvault -split "`t"
        $keyVaultId = $keyvaultItemSlit[0]
        $keyVaultName = $keyvaultItemSlit[1]
        $keyVaultTempName1 = $keyVaultName -replace 'kvietv',''
        $keyVaultTeamName = $keyVaultTempName1 -replace 'aiteuwe1',''
        getKeyVaultSecrets $subscription $keyVaultId $keyVaultName $keyVaultTeamName
    }
}

getKeyVaults "G69 DEV"
