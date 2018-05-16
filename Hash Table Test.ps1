# Hash table testing
Clear-Host
$name = "steven.tobar"

$p = @{property = ('Office','OfficePhone','Department','Manager','Accountexpirationdate','Lockedout','passwordexpired','passwordlastset','whencreated')}


get-aduser $Name -properties * | Select-Object @p | Format-List
<#, 
@{n = 'Office'; e = {$_.office}}
@{n2 = 'Office Phone'; e2 = {$_.officephone}}
@{n3 = 'Department'; e3 = {$_.department}},
@{n4 = 'Manager'; e4 = {(Get-aduser $_.manager).Name}},
@{n5 = 'Account Expiration Date'; e5 = {$_.accountexpirationdate}},
@{n6 = 'Account Locked Out'; e6 = {$_.lockedout}},
@{n7 = 'Password Expired' ; e7 = {$_.passwordexpired}},
@{n8 = 'Password Last Set'; e8 = {$_.passwordlastset}},
@{n9 = 'Account Creation Date' ; e9 = {$_.whencreated}}

#>


