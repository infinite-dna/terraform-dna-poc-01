:: Create root directory and files
mkdir terraform
echo. > terraform\main.tf
echo. > terraform\variables.tf
echo. > terraform\outputs.tf

:: Create modules directory
mkdir terraform\modules

:: Module: resource_group
mkdir terraform\modules\resource_group
echo. > terraform\modules\resource_group\main.tf
echo. > terraform\modules\resource_group\variables.tf
echo. > terraform\modules\resource_group\outputs.tf

:: Module: vnet
mkdir terraform\modules\vnet
echo. > terraform\modules\vnet\main.tf
echo. > terraform\modules\vnet\variables.tf
echo. > terraform\modules\vnet\outputs.tf

:: Module: subnet
mkdir terraform\modules\subnet
echo. > terraform\modules\subnet\main.tf
echo. > terraform\modules\subnet\variables.tf
echo. > terraform\modules\subnet\outputs.tf

:: Module: vm
mkdir terraform\modules\vm
mkdir terraform\modules\vm\windows_vm
mkdir terraform\modules\vm\linux_vm
echo. > terraform\modules\vm\windows_vm\main.tf
echo. > terraform\modules\vm\windows_vm\variables.tf
echo. > terraform\modules\vm\windows_vm\outputs.tf
echo. > terraform\modules\vm\linux_vm\main.tf
echo. > terraform\modules\vm\linux_vm\variables.tf
echo. > terraform\modules\vm\linux_vm\outputs.tf
