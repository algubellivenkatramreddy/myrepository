# Set Session Timout
$initialTimeout = (Get-PowerCLIConfiguration -Scope Session).WebOperationTimeoutSeconds 
Set-PowerCLIConfiguration -Scope Session -WebOperationTimeoutSeconds -1 -Confirm:$False
# End Set Session Timout

# Change these Global Paramenters 
$VIServer = "vapwcvb01vcenter.dstcorp.net"
#$Cluster = "WCVB01JVM"

#Connect to VCenter
$OpenConnection = $global:DefaultVIServers | where { $_.Name -eq $VIServer }
if($OpenConnection.IsConnected) {
    Write-Output "vCenter is Already Connected..."
    $VIConnection = $OpenConnection
} else {
Connect-VIServer -Server $VIServer

}

#Edit this to select a single datastore or leading portion of the names followed but the wildcard character "*"
$DataStores = Get-Datastore -Name WC-9868-WCJVM-* | where{$_.Type -eq 'VMFS'}
foreach ($ds in $DataStores)
  
{ 
#You can select a specific host or a random host by commenting out either of the two lines below
#$esx = Get-VMHost bpspd06.awddev.dstcorp.net -Datastore $ds
$esx = Get-VMHost -Name "dskcwcvb01jvm01.ns.dstcorp.net", "dskcwcvb01jvm09.ns.dstcorp.net"  -Datastore $ds | Get-Random -Count 1
  
$esxcli = Get-EsxCli -VMHost $esx
Write-Host 'Unmapping' $ds on $esx
$esxcli.storage.vmfs.unmap($null, $ds.Name, $null)

Write-Host 'Datastore' $ds.Name ' has been unmapped'
  
}
Write-Host 'Completed all Datastore UN-Mappings'
Write-Host 'Disconnecting from VCENTER' $VIServer

Disconnect-VIServer $VIServer -Confirm:$false 
