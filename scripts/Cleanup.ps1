<#
.SYNOPSIS
    Azure Identity & Governance Cleanup Script
.DESCRIPTION
    Safely removes the resource locks, resource groups, users, and groups 
    created during the project deployment to avoid lingering costs and clutter.
#>

# --- 1. CONFIGURATION ---
$rgName = "RG-Fin-Data-Project"

# --- 2. REMOVE RESOURCE GOVERNANCE ---
Write-Host "Checking for Resource Locks..." -ForegroundColor Cyan
$lock = Get-AzResourceLock -ResourceGroupName $rgName -ErrorAction SilentlyContinue

if ($lock) {
    Write-Host "Removing Resource Lock: $($lock.LockName)..." -ForegroundColor Yellow
    Remove-AzResourceLock -LockId $lock.LockId -Force
}

# --- 3. DELETE AZURE RESOURCES ---
Write-Host "Deleting Resource Group: $rgName..." -ForegroundColor Red
Remove-AzResourceGroup -Name $rgName -Force -AsJob # -AsJob runs it in the background

# --- 4. CLEANUP ENTRA ID (IDENTITY PLANE) ---
Write-Host "Cleaning up Entra ID Users and Groups..." -ForegroundColor Cyan

# Re-fetching IDs to ensure accuracy
$groups = @("Engineering-Lead", "Finance-Auditor")
foreach ($displayName in $groups) {
    $groupId = (Get-MgGroup -Filter "DisplayName eq '$displayName'").Id
    if ($groupId) {
        Remove-MgGroup -GroupId $groupId
        Write-Host "Removed Group: $displayName" -ForegroundColor Yellow
    }
}

$users = @("Alice Test", "Bob Tech")
foreach ($displayName in $users) {
    $userId = (Get-MgUser -Filter "DisplayName eq '$displayName'").Id
    if ($userId) {
        Remove-MgUser -UserId $userId
        Write-Host "Removed User: $displayName" -ForegroundColor Yellow
    }
}

Write-Host "Cleanup process initiated. Note: Resource Group deletion may take a few minutes." -ForegroundColor Green
