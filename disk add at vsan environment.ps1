$cred = Get-Credential
Connect-VIServer -Server vadwcvcenter01 -Credential $cred

$vmname = Get-VM -Name wntemessexchg07

$policy = Get-SpbmStoragePolicy -Name "vSAN FTT.1 Erasure Coding"
$diskadddtask =  New-HardDisk -VM $vmname -CapacityGB 1 -Datastore WC_TESTDEV_VSAN -StoragePolicy $policy -WarningAction SilentlyContinue


Disconnect-VIServer -Server * -Confirm:$false