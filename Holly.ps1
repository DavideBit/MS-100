Write-Host "`nInizio script"

# Trust repository PSGallery
Write-Host "Trust repository PSGallery..."
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# Installazione AzureAD
Write-Host "Installazione AzureAD..."
Install-Module AzureAD

# Connessione ad AzureAD
Write-Host "Connessione ad AzureAD..."
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred

# Definizione del dominio
$domainName = $modAdminCred.username -replace ".*@"

# Preparazione della password per creazione account Holly Dickson
$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$hollyPasswordProfile.Password = "User.pw1"
$hollyPasswordProfile.ForceChangePasswordNextLogin = $false

# Creazione utente Holly Dickson
Write-Host "Creazione utente Holly Dickson..."
New-AzureADUser -AccountEnabled $true -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" `
-UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile -mailNickName "Holly" -UsageLocation "us" | Out-Null

# Assegnazione del ruolo Gloabl Admin ad Holly
Write-Host "Assegnazione Global Admin ad Holly..."
$globalAdminRoleObjectId = (Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -eq "Global Administrator"}).ObjectId
$hollyObjectId = (Get-AzureADUser -ObjectID "Holly@$domainName").ObjectId
Add-AzureADDirectoryRoleMember -ObjectID $globalAdminRoleObjectId -RefObjectId $hollyObjectId

# Assegnazione delle licenze ad Holly
Write-Host "Assegnazione delle licenze ad Holly..."
$planNames= @("EMSPREMIUM","ENTERPRISEPREMIUM")
foreach ($plan in $planNames) {
    $LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $plan -EQ).SkuID
    $LicensesToAssign.AddLicenses = $License
    Set-AzureADUserLicense -ObjectId $hollyObjectId -AssignedLicenses $LicensesToAssign
}

Write-Host "`nFatto"
