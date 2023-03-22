# Trust repository PSGallery
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Host "`nTrust repository PSGallery completato`n" -ForegroundColor DarkGreen

# Installazione AzureAD
Install-Module AzureAD
Write-Host "`nInstallazione AzureAD completata`n" -ForegroundColor DarkGreen

# Connessione ad AzureAD
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred
Write-Host "`nConnessione ad AzureAD completata`n" -ForegroundColor DarkGreen

# Definizione del dominio
$domainName = $modAdminCred.username -replace ".*@"

# Preparazione della password per creazione account Holly Dickson
$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$hollyPasswordProfile.Password = "User.pw1"
$hollyPasswordProfile.ForceChangePasswordNextLogin = $false

# Creazione utente Holly Dickson
New-AzureADUser -AccountEnabled $true -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" -UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile -mailNickName "Holly"
Write-Host "`nCreazione utente Holly Dickson completata`n" -ForegroundColor DarkGreen

# Assegnazione del ruolo Gloabl Admin ad Holly
$GlobalAdminRole = Get-AzureADDirectoryRoleTemplate | Where-Object {$_.DisplayName -eq "Global Administrator"}
Enable-AzureADDirectoryRole -RoleTemplateId $GlobalAdminRole.ObjectId
Write-Host "`nAssengazione ad Holly Global Admin completata`n" -ForegroundColor DarkGreen