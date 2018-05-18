<#
.Synopsis
   Gets the user's properties and allows the technician to make changes to the password or lock state if needed
.DESCRIPTION
   When given a username, the script will find the user's properties. If the account is locked out or if the password is expired, it'll prompt the tech to fix it. 
.NOTES
    Created by Steven Tobar 4/6/18
    Assumes a few things: Correct first and last name and a legitimate name is used (i.e. 'John.Smith' and not 'cnwe.uiyf')
    Bugs: using firstinitial.lastname will not work.
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
            Write-Host "Both passwords must match. Please re-enter them. `n" -ForegroundColor Yellow
            $matched = $True
        } 
        else 
        {
            Break
        } 
    } while ($matched)
}


function Get-ValidUserName
{  
    Do
    { 
        Try
        {   Clear-Host
            $Real = $false  
            Write-Host "Format: firstname.lastname`n" -ForegroundColor Yellow 
            $Name = Read-Host -Prompt "Please enter a username"
            $FullName = $Name.Replace("."," ")
            $script:ValidUser = Get-ADUser -filter {name -eq $FullName} | Select-Object -expandproperty samaccountname
            Write-Output $ValidUser
        }
        Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
        {
            Clear-Host  
            Write-Host "This user does not exist. `n"
            $Real = $true
        }
        Catch
        {
            Clear-host
            Write-Host "The prompt cannot be empty. Please enter a valid username. `n"
            $Real = $true
        }
    }  
    While ($Real)      
}


function Get-UserProperties()   
{
    [cmdletbinding()]
    param
    (
        [parameter(Mandatory = $true,
        ValueFromPipeline = $true)]
        $Name    
    )
    $UserProperties = Get-aduser $ValidUser -properties * | 
    Select-Object   @{n = 'Office'; e = {$_.office}},
                    @{n = 'Office Phone'; e = {$_.officephone}},
                    @{n = 'Department'; e = {$_.department}},
                    @{n = 'Manager'; e = {(Get-aduser $_.manager).Name}},
                    @{n = 'Account Locked Out'; e = {$_.lockedout}},
                    @{n = 'Password Expired' ; e = {$_.passwordexpired}},
                    @{n = 'Password Last Set'; e = {$_.passwordlastset}},
                    @{n = 'Account Creation Date' ; e = {$_.whencreated}},
                    @{n = 'Account Expiration Date'; e = {$_.accountexpirationdate}}
    Write-Output $UserProperties
}    

function Set-LockState
{  
    if ($UserProperties.'Account Locked Out' -eq $true)
    {
        Unlock-ADAccount $ValidUser -Confirm
    }
}


function Set-Password
{   
    if ($UserProperties.'Password Expired' -eq $false)
    {   
        Get-NewPassword
        Set-ADAccountPassword $ValidUser -Reset -NewPassword $ConfirmNewPassword
        Write-Host "The password has been reset. `n" -ForegroundColor Yellow          
    }    
}


Get-ValidUserName | Get-UserProperties 
Set-LockState 
Set-Password 









