The following script will save all rules to a .txt file.

$outfile = "C:\rules.txt"
Remove-Item $outfile
$clusterName = <cluster-name>
$rules = get-cluster -Name $clusterName | Get-DrsRule

foreach($rule in $rules){
  $line = (Get-View -Id $rule.ClusterId).Name
  $line += ("," + $rule.Name + "," + $rule.Enabled + "," + $rule.KeepTogether)
  foreach($vmId in $rule.VMIds){
    $line += ("," + (Get-View -Id $vmId).Name)
  }
  $line | Out-File -Append $outfile 
}
The reason we write the rules to a .txt file is because the "Keep together" type of rules can have 2 or more guests defined.

This type of info (variable length array) is impossible to export to a .CSV file.

 

The 2nd script reads this external file and defines the rules.

$file = "C:\rules.txt"
$rules = Get-Content $file

foreach($rule in $rules){
  $ruleArr = $rule.Split(",")
  if($ruleArr[2] -eq "True"){$rEnabled = $true} else {$rEnabled = $false}
  if($ruleArr[3] -eq "True"){$rTogether = $true} else {$rTogether = $false}
  get-cluster $ruleArr[0] | `
    New-DrsRule -Name $ruleArr[1] -Enabled $rEnabled -KeepTogether $rTogether -VM (Get-VM -Name ($ruleArr[http://4..($ruleArr.Count - 1)|http://4..($ruleArr.Count - 1)])) 
}