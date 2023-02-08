## Create AD groups
Write-Host '# Create an AD Admin group. (Press any key to continue)';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
Write-Host '=> az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup';
az ad group create --display-name patrickAKSAdminGroup --mail-nickname patrickAKSAdminGroup
az ad group create --display-name patrickAKSApiDevGroup --mail-nickname patrickAKSApiDevGroup
az ad group create --display-name patrickAKSWebDevGroup --mail-nickname patrickAKSWebDevGroup