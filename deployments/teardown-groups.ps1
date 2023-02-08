# Cleanup Groups
Write-Host '=> Delete whole resource group.';
Write-Host '   Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

## Delete AD group
Write-Host '=> az ad group delete *';
az ad group delete --group patrickAKSAdminGroup
az ad group delete --group patrickAKSApiDevGroup
az ad group delete --group patrickAKSWebDevGroup

Write-Host '# Deleted everything!';