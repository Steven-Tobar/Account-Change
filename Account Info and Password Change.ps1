<#
.Synopsis
   Gets the user's properties and allows the technician to make changes to the password or lock state if needed

.DESCRIPTION
   When given a username, the script will find the user's properties. If the account is locked out or if the password is expired, it'll prompt the tech to fix it.
.NOTES
    Created by Steven Tobar 4/6/18
#>
function Get-NewPassword
{
    <#
    .Synopsis
    Changes the password to an account on the domain.

    .Description
    This command asks the tech to enter a new password and verifies that they're the same password before assigning it to the account. The function will loop
    back until both passwords are the same.
    #>

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
    <#
    .SYNOPSIS
    Asks the tech to give a username in either format and looks up if their account exists.

    .DESCRIPTION
    After entering a username, the command will find the account. A blanket "user does not exist" will show if the username is wrong or
    it actually can't be found and will loop back.
    If the tech just presses enter, the error message should tell them that and loop back. Should.
    #>

    Do
    {
        Write-Host "Format: john.smith or jsmith`n" -ForegroundColor Yellow
        $Name = Read-Host -Prompt "Please enter a username"
        $Real = $false

        Try
        {
            $script:ValidUser = Get-ADUser $Name | Select-Object -expandproperty samaccountname
            Write-Output $ValidUser
        }
        Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
        {
            Clear-Host
            Write-Host "This user does not exist. `n" -ForegroundColor Red
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
    <#
    .SYNOPSIS
    Gets the user's properties via the custom properties in the hash table. There's probably a better way of doing this.

    .DESCRIPTION
    The command will generate a custom hash table showcasing vital information for the tech.
    #>

    param
    (
        [parameter(
        ValueFromPipeline = $true)]
        $Identity
    )
    Begin{}

    Process
    {
    $script:UserProperties = Get-aduser $Identity -properties * |
    Select-Object   @{n = 'Office'; e = {$_.office}},
                    @{n = 'Office Phone'; e = {$_.officephone}},
                    @{n = 'Department'; e = {$_.department}},
                    @{n = 'Manager'; e = {(Get-aduser $_.manager).Name}},
                    @{n = 'Account Locked Out'; e = {$_.lockedout}},
                    @{n = 'Password Expired' ; e = {$_.passwordexpired}},
                    @{n = 'Password Last Set'; e = {$_.passwordlastset}},
                    @{n = 'Account Creation Date' ; e = {$_.whencreated}},
                    @{n = 'Account Expiration Date'; e = {$_.accountexpirationdate}}
    }
    End
    {
        Write-Output $UserProperties
    }
}

function Set-LockState
{
    <#
    .SYNOPSIS
    Using the output from Get-UserProperties, the lock state is checked.

    .DESCRIPTION
    The command uses the properties from Get-UserProperties to check if the account is locked. If it is, it'll unlock it and tell the tech it's doing so.
    #>
    if ($UserProperties.'Account Locked Out' -eq $true)
    {
        Write-Host "Unlocking the account. Please confirm." -ForegroundColor Yellow
        Unlock-ADAccount $ValidUser -Confirm
    }
}


function Set-Password
{
    <#
    .SYNOPSIS
    Checks for the user's password state and changes it.

    .DESCRIPTION
    Uses the properties from Get-UserProperties to check if the password is expired. If it is, it'll call Get-NewPassword and reset the user's password.
    #>

    if ($UserProperties.'Password Expired' -eq $true)
    {
        Get-NewPassword
        Write-Host "Resetting the user password." -ForegroundColor Yellow
        Set-ADAccountPassword $ValidUser -Reset -NewPassword $ConfirmNewPassword
        Write-Host "The password has been reset. `n" -ForegroundColor Yellow
    }
}

$n = 0

while ($n -lt 5)
{
    #Loops through the script a maximum of 5 times before the scripts stops. It will notify the tech of how many tries they have left.
    Get-ValidUserName | Get-UserProperties
    Set-LockState
    Set-Password
    $n++
    $m = 5-$n
    Write-Host "There are $m more account lookups left `n" -ForegroundColor Cyan
}










