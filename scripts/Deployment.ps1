<#
.SYNOPSIS
    Azure Identity & Governance Framework Deployment
.DESCRIPTION
    Automates the creation of Entra ID users, security groups, and RBAC assignments
    at the Resource Group scope for the AZ-104 portfolio project.
#>

# --- 1. CONFIGURATION ---
$rgName = "RG-Fin-Data-Project"
$location = "EastUS"
$csvPath = ".\Users.csv" # Ensure this file exists in your directory

# --- 2. USER PROVISIONING ---
$users = Import-Csv -Path $csvPath
$passwordProfile = @{ Password = "ComplexPassword123!"; ForceChangePasswordNextSignIn = $true }

foreach ($user in $users) {
    $userSplat = @{
        DisplayName       = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MailNickname      = $user.MailNickname
        UsageLocation     = $user.UsageLocation
        JobTitle          = $user.JobTitle
        AccountEnabled    = $true
        PasswordProfile   = $passwordProfile
    }
    New-MgUser @userSplat
}

# --- 3. GROUP & INFRASTRUCTURE SETUP ---
New-MgGroup -DisplayName "Engineering-Lead" -MailEnabled $false -MailNickname "engleads" -SecurityEnabled $true
New-MgGroup -DisplayName "Finance-Auditor" -MailEnabled $false -MailNickname "finaudit" -SecurityEnabled $true

New-AzResourceGroup -Name $rgName -Location $location

# --- 4. RBAC ASSIGNMENTS ---
$engId = (Get-MgGroup -Filter "DisplayName eq 'Engineering-Lead'")[0].Id
$finId = (Get-MgGroup -Filter "DisplayName eq 'Finance-Auditor'")[0].Id
$rgScope = (Get-AzResourceGroup -Name $rgName).ResourceId

New-AzRoleAssignment -ObjectId $finId -RoleDefinitionName "Reader" -Scope $rgScope
New-AzRoleAssignment -ObjectId $engId -RoleDefinitionName "Contributor" -Scope $rgScope

# --- 5. GOVERNANCE LOCK ---
New-AzResourceLock -LockName "ProtectProject" -LockLevel "CanNotDelete" -ResourceGroupName $rgName

Write-Host "Deployment Complete. Identity and Governance Framework is live." -ForegroundColor Green
