

<#
.Synopsis
   Gets the user's properties and allows the technician to make changes
.DESCRIPTION
   When given a username, the script will find the user's properties. If the account is locked out or if the password is expired, it'll prompt the tech to fix it. 
.NOTES
    Created by Steven Tobar 4/6/18
    Assumes a few things: Correct first and last name and no random jumble
#>


function Get-ValidUser()
{  
    param
    ( 
        [string]$script:Identity
    )    
        $FullName = $Identity.Replace("."," ")
        $ValidUser = Get-ADUser -filter {name -eq $FullName} |Select-Object -expandproperty samaccountname
        Write-Output "Their username is actually: $ValidUser `n"
}

function Get-UserProperties()   
{
    param
    ( 
        [string]$script:ADUser
    )
     
    $script:UserProperties = get-aduser $ADUser -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated    
}
    
function Get-LockState
{  
    Get-UserProperties $Name
    if ($UserProperties.lockedout -eq $true)
    {
        Unlock-ADAccount $Name -Confirm
    }
}

function Get-PasswordState
{
    Get-UserProperties $Name
    if ($UserProperties.passwordexpired -eq $true)
    {
        $NewPassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        Set-ADAccountPassword $Name -NewPassword $NewPassword        
    }    
}

Clear-Host

Do 
{   $script:Name = Read-Host -Prompt "Please enter a username in the format first.name"
    $doesntexist = $false
    Try
    {   
        Get-UserProperties $Name  
        Write-Output $UserProperties
        Get-LockState 
        Get-PasswordState   
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
     {
      #Catches the exception errors for users that don't exist and provides the tech with a valid username to enter.
       Clear-Host
       Get-ValidUser($Name)
       $DoesntExist = $True    
     }
}

while ($DoesntExist)








