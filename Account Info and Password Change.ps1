

<#
.Synopsis
   Gets the user's properties and allows the technician to make changes
.DESCRIPTION
   When given a username, the script will find the user's properties. If the account is locked out or if the password is expired, it'll prompt the tech to fix it.
.NOTES
    Created by Steven Tobar 4/6/18
#>

function Get-ValidUser ()
{   [cmdletbinding()]
    param( 
        [parameter(
            Mandatory = $true, 
            HelpMessage = "Please enter a username in the format first.lastname" 
        )] 
        [string]$script:Identity
    )
        $firstname,$lastname = $Identity.Split(".")
        $fullname = $firstname + " " + $lastname
        $validuser = Get-ADUser -filter {name -eq $fullname} |Select-Object -expandproperty samaccountname
        #Write-Output "Their username is actually: $validuser `n"
}

function Get-UserProperties
{
   #Get basic user properties that can help the tech find out what's wrong with a user account.
    $script:userproperties = get-aduser $Identity -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated    
}
    
function Get-LockState
{  #Takes the user and checks to see if they are locked out of their account; if they are, the tech is prompted to change that.
    Get-UserProperties $Identity
    if ($userproperties.lockedout -eq $true)
    {
        Unlock-ADAccount $name -Confirm
    }
}

function Get-PasswordState
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
    {   Get-ValidUser $name
        Get-UserProperties  
        Write-Output $userproperties
        Get-LockState 
        Get-PasswordState   
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








