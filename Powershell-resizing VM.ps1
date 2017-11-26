#resizing vm
$rgname="name of resource group"
$vmname="name of vm"





Stop-AzureRmVM -ResourceGroupName $rgname -Name $vmname -Force
$vm = Get-AzureRmVM -ResourceGroupName $rgname  -VMName $vmname
$vm.HardwareProfile.VmSize = "Standard_F4s"
Update-AzureRmVM -VM $vm -ResourceGroupName $rgname
Start-AzureRmVM -ResourceGroupName $rgname  -Name $vm.name