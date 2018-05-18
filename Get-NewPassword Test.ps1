function Get-NewPass
{
    $Matched = $false
    Do 
    {
        $NewPassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        $script:ConfirmNewPassword = Read-host -Prompt "Confirm new password" -AsSecureString
        $NewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword))
        $ConfirmNewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmNewPassword))
        
        if ($NewPasswordText -cne $ConfirmNewPasswordText)
        {   
            Clear-Host
            Write-Host "Both passwords must match. Please re-enter them.`n" -ForegroundColor Yellow
            $matched = $True
        }  
        else {
            Break
        }

    } while ($matched)
}

Get-NewPass
Set-adaccountpassword "steven.tobar" -Reset -NewPassword $ConfirmNewPassword



