# Credenziali amministazione principale
<#
$domainName = "xxx"
# Attenzione: $modAdminName deve essere nella forma "domain\user"
$modAdminName = "admin\$domainName"
$modAdminPassword = "xxx"

$modCredentials = New-Object System.Management.Automation.PSCredential $modAdminName,$modAdminPassword
#>


Write-Host "Trust repository PSGallery"
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Write-Host "Trust repository PSGallery" -ForegroundColor Green

Write-Host "Installazione AzureAD"
Install-Module AzureAD
Write-Host "Installazione AzureAD" -ForegroundColor Green

Write-Host "Connessione ad AzureAD"
$modAdminCred = Get-Credential
Connect-AzureAD -Credential $modAdminCred
Write-Host "Connessione ad AzureAD" -ForegroundColor Green

# Creazione utente Holly Dickson

$hollyPasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
# Attenzione: inserire qui la password di Holly Dickson
$hollyPasswordProfile.Password = "User.pw1"

New-AzureADUser -DisplayName "Holly Dickson" -GivenName "Holly" -Surname "Dickson" -UserPrincipalName "Holly@$domainName" -PasswordProfile $hollyPasswordProfile
# Da finire in modo che non venga cambiata la password.
#Risorse: 
#https://learn.microsoft.com/en-us/powershell/module/azuread/new-azureaduser?view=azureadps-2.0
#https://howardsimpson.blogspot.com/2021/10/enforcechangepasswordpolicy-in-new-azureaduser-and-set-azureaduserpassword.html