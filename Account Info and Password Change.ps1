#Created by Steven Tobar 4/6/18


function Get-ValidUser()
{
  #Gets the SamAccountName for the user in AD
    <#if ($name -eq " ")
    {
        "The username can't be blank."
    }
    elseif($name -notcontains ".")
    {
        "Please type the username with the correct format."
    }
    else
    { #>
        #Assumes no name mispellings 
        $firstname,$lastname = $name.Split(".")
        $fullname = $firstname + " " + $lastname
        $validuser = Get-ADUser -filter {name -eq $fullname} |Select-Object -expandproperty samaccountname
        Write-Output "Their username is actually: $validuser `n"
    #}
}

function Get-UserProperties
{
    param($user)
   #Get basic user properties that can help the tech find out what's wrong with a user account.
    $script:userproperties = get-aduser $user -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated    
}
    
function Check-LockState
{  #Takes the user and checks to see if they are locked out of their account; if they are, the tech is prompted to change that.
    Get-UserProperties $name
    if ($userproperties.lockedout -eq $true )
    {
        Unlock-ADAccount $name -Confirm
    }
}

function Check-PasswordState
{  #Checks to see if the user's password is expired; if true the tech is prompted to give a new password.
    Get-UserProperties $name
    if ($userproperties.passwordexpired -eq $true)
    {
        $newpassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        Set-ADAccountPassword $name -NewPassword $newpassword        
    }    
}

Clear-Host

Do 
{   $script:name = Read-Host -Prompt "Please enter a username in the format first.name"
    $doesntexist = $false
    Try
    {   
        Get-UserProperties $name 
        Write-Output $userproperties
        Check-LockState 
        Check-PasswordState   
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
     {
      #Catches the exception errors for users that don't exist and provides the tech with a valid username to enter.
       Clear-Host
       Get-ValidUser($name)
       $doesntexist = $true    
     }
}

while ($doesntexist)








