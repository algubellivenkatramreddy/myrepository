
#
# PowerCLI Script to export DRS Rules
# Created by BLiebowitz on 6/26/2017
#
#####################################################
 
# Build an array for each vCenter to connect to
$array = "vCenter1", "vCenter2", "vCenter3"
for($count=0;$count -lt $array.length; $count++)
{
# Connect to vCenter
connect-viserver $array[$count]
 
# Set the export file name &amp; folder location.
$export = "E:\vmware\DRS\$($array[$count])_DRSrules_$((Get-Date).ToString('MM-dd-yyyy')).txt"
 
# Get the clusters to export rules from
$clusters = get-cluster
 
# Find and export rules for each cluster
foreach ($cluster in $clusters) {
 
# Find all the rules
$rules = get-cluster -Name $cluster | Get-DrsRule
 
# Export each rule
foreach($rule in $rules){
$line = (Get-View -Id $rule.ClusterId).Name
$line += ("," + $rule.Name + "," + $rule.Enabled + "," + $rule.KeepTogether)
 
foreach($vmId in $rule.VMIds){
$line += ("," + (Get-View -Id $vmId).Name)
}
# Write each rule to a file.
$line | add-content $export –force
 
# Disconnect from vCenter
disconnect-viserver $array[$count] –confirm:$false
 
}
}
}