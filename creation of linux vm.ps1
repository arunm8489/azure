

$rgname="aruntest"
$location="EastUs"

$subnetname="mysubnet"
$vnetname="myvnet"
$rule1="httpd"
$nsggroupname="mynsggroup"
$nsgcardname="mynsgcard"

$vmname="myvm"
$vmsize=Standard_D1
$computername=linux123


#creating resouce group
New-AzureRmResourceGroup -ResourceGroupName $rgname -Location $location

#subnet conf
$subnetconf=New-AzureRmVirtualNetworkSubnetConfig -Name $subnetname -AddressPrefix 10.0.0.0/24

#vnet conf(name,addressprefix,resource group name,location,subnet)
$vnetconf=New-AzureRmVirtualNetwork -Name $vnetname -AddressPrefix 10.0.0.0/16 -ResourceGroupName $rgname -Location $location -Subnet $subnetconf

#pub ip(name,allocation method,resource groupname,location)
$pip=New-AzureRmPublicIpAddress -Name mypubaddress -AllocationMethod Dynamic -ResourceGroupName $rgname -Location $location

#security rules(Important parameters – Name, Protocol, Direction, Priority, SourceAddressPrefix, SourcePortRange, DestinationAddressPrefix, DestinationPortRange, Access)
$nsgrule1=New-AzureRmNetworkSecurityRuleConfig -Name $rule1 -Direction Inbound -Priority 100 -Protocol Tcp -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 80 -Access Allow

#nsggroup
$nsg=New-AzureRmNetworkSecurityGroup -Name $nsggroupname -SecurityRules $nsgrule1 -ResourceGroupName $rgname -Location $location

#niccard
$nic=New-AzureRmNetworkInterface -Name $nsgcardname -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.id -SubnetId $vnetconf.subnets[0].Id -ResourceGroupName $rgname -Location $location

#credentials for vm
$adminUsername = 'labadmin'
$adminPassword = 'redhat@123456'
$cred = New-Object PSCredential $adminUsername, ($adminPassword | ConvertTo-SecureString -AsPlainText -Force)

#vmconfiguration
$vm=New-AzureRmVMConfig -VMName $vmname -VMSize $vmsize
$vm=Set-AzureRmVMOperatingSystem -Linux -ComputerName $computername -Credential $cred -VM $vm
$vm = Set-AzureRmVMSourceImage -PublisherName Canonical -Offer UbuntuServer -Skus 14.04.2-LTS -Version latest -VM $vm
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

New-AzureRmVM -ResourceGroupName $rgname -Location $location -VM $vm
