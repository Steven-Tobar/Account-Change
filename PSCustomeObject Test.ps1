$Prop = Get-aduser steven.tobar -properties *
    <# Select-Object   @{n = 'Office'; e = {$_.office}},
                    @{n = 'Office Phone'; e = {$_.officephone}},
                    @{n = 'Department'; e = {$_.department}},
                    @{n = 'Manager'; e = {(Get-aduser $_.manager).Name}},
                    @{n = 'Account Locked Out'; e = {$_.lockedout}},
                    @{n = 'Password Expired' ; e = {$_.passwordexpired}},
                    @{n = 'Password Last Set'; e = {$_.passwordlastset}},
                    @{n = 'Last Bad Password Attempt'; e = {$_.lastbadpasswordattempt}},
                    @{n = 'Account Creation Date' ; e = {$_.whencreated}},
                    @{n = 'Account Expiration Date'; e = {$_.accountexpirationdate}} 
    #>
$Prop2 = [PSCustomObject]@{
    'Office Phone' = $prop.OfficePhone
    Name = $prop.Name
    Department = $prop.Department
    Manager = (get-aduser $prop.Manager).Name
    'Account Locked Out' = $prop.LockedOut
    'Password Expired' = $prop.PasswordExpired
    'Last Bad Password Attempt' = $prop.LastBadPasswordAttempt
    'Account Creation Date' = $prop.whenCreated
    'Account Expiration Date' = $prop.AccountExpirationDate 
}
cls
$prop2
