    $name = Read-Host -Prompt "Please enter the username"

    $usercheck = Get-ADUser -Filter {SAMaccountName -eq $name}
    
    
while ($true)
{    
    $name = Read-Host -Prompt "Please enter the username"

    $usercheck = Get-ADUser -Filter {SAMaccountName -eq $name}
    
    if ($usercheck -eq $null)
    {
    echo "The user does not exist"
    }
    break
    else 
    {
    echo "user found in AD"
    }
    break
}     