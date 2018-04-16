$name = Read-Host -Prompt "Please enter the username"



$userproperties = get-aduser $name -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated



if ($userproperties.passwordexpired -eq $true)
{ 
    $newpassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
    Set-ADAccountPassword $name -NewPassword $newpassword
}