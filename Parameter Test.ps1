function Check-UserProperties
{
param ($test)

    Get-ADUser $test -Properties samaccountname 
}

Check-UserProperties $n