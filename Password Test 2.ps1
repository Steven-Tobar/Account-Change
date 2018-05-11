
    Do 
    {
        Clear-host
        Write-host "Comparing two passwords starts now!"
        $NewPassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        $ConfirmNewPassword = Read-host -Prompt "Confirm new password" -AsSecureString
        $NewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($NewPassword))
        $ConfirmNewPasswordText = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($ConfirmNewPassword))
    } 
    while ($NewPasswordText -cne $ConfirmNewPasswordText)
    Write-Output $NewPassword
    Write-Output $NewPasswordText
    Write-Output $ConfirmNewPassword
    Write-Output $ConfirmNewPasswordText
    
