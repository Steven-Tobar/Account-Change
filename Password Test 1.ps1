
    Do 
    {
        $Matched = $false
        clear-host
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