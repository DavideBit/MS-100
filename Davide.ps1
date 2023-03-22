Write-Host "`nInizio`n" -ForegroundColor Green

# Trust repository PSGallery
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Host "`nTrust repository PSGallery completato`n" -ForegroundColor Green

# Installazione AzureAD
Install-Module AzureAD
Write-Host "`nInstallazione AzureAD completata`n" -ForegroundColor Green

# Connessione ad AzureAD
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred
Write-Host "`nConnessione ad AzureAD completata`n" -ForegroundColor Green

# Definizione del dominio
$domainName = $modAdminCred.username -replace ".*@"

# Preparazione della password per creazione account Holly Dickson
$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$hollyPasswordProfile.Password = "User.pw1"
$hollyPasswordProfile.ForceChangePasswordNextLogin = $false

# Creazione utente Holly Dickson
New-AzureADUser -AccountEnabled $true -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" -UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile -mailNickName "Holly"
Write-Host "`nCreazione utente Holly Dickson completata`n" -ForegroundColor Green

# Assegnazione del ruolo Gloabl Admin ad Holly
$globalAdminRoleObjectId = (Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -eq "Global Administrator"}).ObjectId
$hollyObjectId = (Get-AzureADUser -ObjectID "Holly@$domainName").ObjectId
Add-AzureADDirectoryRoleMember -ObjectID $globalAdminRoleObjectId -RefObjectId $hollyObjectId
Write-Host "`nAssengazione ad Holly Global Admin completata`n" -ForegroundColor Green

Write-Host "`nFinito`n" -ForegroundColor Green