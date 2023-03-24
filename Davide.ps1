Write-Host "Inizio script"

# Trust repository PSGallery
Write-Host "`nTrust repository PSGallery..."
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Host "OK" -ForegroundColor Green -NoNewline

# Installazione AzureAD
Write-Host "`nInstallazione AzureAD..."
Install-Module AzureAD
Write-Host "OK" -ForegroundColor Green -NoNewline

# Connessione ad AzureAD
Write-Host "`nConnessione ad AzureAD..."
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred
Write-Host "OK" -ForegroundColor Green -NoNewline

# Definizione del dominio
$domainName = $modAdminCred.username -replace ".*@"

# Preparazione della password per creazione account Holly Dickson
$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$hollyPasswordProfile.Password = "User.pw1"
$hollyPasswordProfile.ForceChangePasswordNextLogin = $false

# Creazione utente Holly Dickson
Write-Host "`nCreazione utente Holly Dickson..."
New-AzureADUser -AccountEnabled $true -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" `
-UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile -mailNickName "Holly" -UsageLocation "us"
Write-Host "OK" -ForegroundColor Green -NoNewline

# Assegnazione del ruolo Gloabl Admin ad Holly
Write-Host "`nAssegnazione Global Admin ad Holly..."
$globalAdminRoleObjectId = (Get-AzureADDirectoryRole | Where-Object {$_.DisplayName -eq "Global Administrator"}).ObjectId
$hollyObjectId = (Get-AzureADUser -ObjectID "Holly@$domainName").ObjectId
Add-AzureADDirectoryRoleMember -ObjectID $globalAdminRoleObjectId -RefObjectId $hollyObjectId
Write-Host "OK" -ForegroundColor Green -NoNewline

Write-Host "`nFinito" -ForegroundColor Green