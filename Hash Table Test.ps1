# Hash table testing
Clear-Host
$name = "steven.tobar"

#$p = @{property = ('Office','OfficePhone','Department','Manager','Accountexpirationdate','Lockedout','passwordexpired','passwordlastset','whencreated')}


get-aduser $Name -Properties * | 
Select-Object @{n = 'Office'; e = {$_.office}},
@{n = 'Office Phone'; e = {$_.officephone}},
@{n = 'Department'; e = {$_.department}},
@{n = 'Manager'; e = {(Get-aduser $_.manager).Name}},
@{n = 'Account Locked Out'; e = {$_.lockedout}},
@{n = 'Password Expired' ; e = {$_.passwordexpired}},
@{n = 'Password Last Set'; e = {$_.passwordlastset}},
@{n = 'Account Creation Date' ; e = {$_.whencreated}},
@{n = 'Account Expiration Date'; e = {$_.accountexpirationdate}}




