function Get-ValidUserName()
{  
    Do
    { 
        Try
        {
            $Real = $false  
            Write-Host "Format: firstname.lastname`n" -ForegroundColor Green 
            $Name = Read-Host -Prompt "Please enter a username"
            $FullName = $Name.Replace("."," ")
            $script:ValidUser = Get-ADUser -filter {name -eq $FullName} | Select-Object -expandproperty samaccountname
            Write-Output $ValidUser
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
        {
            Clear-Host  
            Write-Host "This user does not exist. `n"
            $Real = $true
        }
        catch
        {
            Clear-host
            Write-Host "The prompt cannot be empty. Please enter a valid username. `n"
            $Real = $true
        }
    }  
    While ($Real)      
}

Get-ValidUserName | get-aduser