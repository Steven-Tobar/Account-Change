

<#
.Synopsis
   Gets the user's properties and allows the technician to make changes
.DESCRIPTION
   When given a username, the script will find the user's properties. If the account is locked out or if the password is expired, it'll prompt the tech to fix it. 
.NOTES
    Created by Steven Tobar 4/6/18
    Assumes a few things: Correct first and last name and no random jumble
#>

function Get-NewPassword
{
    $Matched = $false
    Do 
    {
        $NewPassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        $ConfirmNewPassword = Read-host -Prompt "Confirm new password" -AsSecureString
        $NewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword))
        $ConfirmNewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmNewPassword))
    
        if ($NewPasswordText -cne $ConfirmNewPasswordText)
        {
            Write-Output "The New and Confirm password must match. Please re-enter them."
            $matched = $True
        }  
    } while ($matched)
}
function Get-ValidUserName()
{  
    param
    ( 
        [string]$script:Identity
    )    
        $FullName = $Identity.Replace("."," ")
        $script:ValidUser = Get-ADUser -filter {name -eq $FullName} | Select-Object -expandproperty samaccountname
        Write-Output "Their username is actually: $ValidUser `n"
}

function Get-UserProperties()   
{
    $script:UserProperties = get-aduser $Name -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated    
}
    
function Set-LockState
{  
    if ($UserProperties.lockedout -eq $true)
    {
        Unlock-ADAccount $Name -Confirm
    }
}

function Set-Password
{   
    if ($UserProperties.passwordexpired -eq $false)
    {   
        Get-NewPassword | Set-ADAccountPassword $Name -NewPassword $ConfirmNewPassword
        Write-Output "The password has been reset."          
    }    
}

Clear-Host

Do 
{   
    $Name = Read-Host -Prompt "Please enter a username in the format first.name"
    $DoesntExist = $false
    
    Try
    {   
        Write-Output $UserProperties
        Get-UserProperties $Name | Set-LockState 
        Get-UserProperties $Name | Set-Password 
          
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
     {
      #Catches the exception errors for users that don't exist and provides the tech with a valid username to enter.
       Clear-Host
       Get-ValidUserName $Name #| Get-UserProperties 
       $DoesntExist = $True
     }
}

while ($DoesntExist)








