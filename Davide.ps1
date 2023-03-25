Write-Host "Inizio script"

# Trust repository PSGallery
Write-Host "`nTrust repository PSGallery..." -NoNewline
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Host " OK" -ForegroundColor Green 

# Installazione AzureAD
Write-Host "`nInstallazione AzureAD..." -NoNewline
Install-Module AzureAD
Write-Host " OK" -ForegroundColor Green 

# Connessione ad AzureAD
Write-Host "`nConnessione ad AzureAD..." -NoNewline
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred
Write-Host " OK" -ForegroundColor Green 

# Definizione del dominio
$domainName = $modAdminCred.username -replace ".*@"

# Preparazione della password per creazione account Holly Dickson
$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$hollyPasswordProfile.Password = "User.pw1"
$hollyPasswordProfile.ForceChangePasswordNextLogin = $false

# Creazione utente Holly Dickson
Write-Host "`nCreazione utente Holly Dickson..." -NoNewline
New-AzureADUser -AccountEnabled $true -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" `
-UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile -mailNickName "Holly" -UsageLocation "us"
Write-Host " OK" -ForegroundColor Green 

# Assegnazione del ruolo Gloabl Admin ad Holly
Write-Host "`nAssegnazione Global Admin ad Holly..." -NoNewline
$globalAdminRoleObjectId = (Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -eq "Global Administrator"}).ObjectId
$hollyObjectId = (Get-AzureADUser -ObjectID "Holly@$domainName").ObjectId
Add-AzureADDirectoryRoleMember -ObjectID $globalAdminRoleObjectId -RefObjectId $hollyObjectId
Write-Host " OK" -ForegroundColor Green 

# Assegnazione delle licenze ad Holly
Write-Host "`nAssegnazione delle licenze ad Holly..." -NoNewline
$planNames= @("EMSPREMIUM","ENTERPRISEPREMIUM")
$LicensesToAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
foreach ($plan in $planNames) {
    $License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
    $License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $plan -EQ).SkuID
    $LicensesToAssign.AddLicenses = $License
}
Set-AzureADUserLicense -ObjectId $hollyObjectId -AssignedLicenses $LicensesToAssign
Write-Host " OK" -ForegroundColor Green



Write-Host "`nFinito" -ForegroundColor Green