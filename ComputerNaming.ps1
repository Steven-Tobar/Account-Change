﻿
Function Get-ComputerName
{

    $Location = Read-Host -Prompt "Please enter 'T' for Trade and 'L' for Learning"

if ($Location -eq "T")
{
    $FTemplate = "ComputerName-"
   
    
    $F = Get-ADComputer -filter 'Name -like "ComputerName-1*"' -SearchBase "$ComputerOU" | select name | sort name
    
    $LastComputerF = $F[-1].name
    
    [int]$DigitsF = $LastComputerF.substring($LastComputerF.lastindexof("-")+1)
    #Takes the last 4 digits of the computer name from the last computer in F with the name ComputerName-1XXX and spits out the digits "1XXX". 
    
    $DigitsF += 1

    $NewFComputerName = -join($FTemplate,$DigitsF)
    
    Write-Output $NewFComputerName    
}
elseif($Location -eq "L")
{
    $NTemplate = "ComputerName-"
    
    $N = Get-ADComputer -filter 'Name -like "ComputerName-0*"' -SearchBase "$ComputerOU" | select name | sort name
    
    $LastComputerN = $N[-1].name
    
    [int]$DigitsN = $LastComputerN.substring($LastComputerN.lastindexof("-")+1)
    #Takes the last 4 digits of the computer name from the last computer in N with the name Computer-0XXX and spits out the digits "1XXX". 
    
    $DigitsNYP += 1

    $NewNComputerName = -join($NTemplate,$DigitsN)

    Write-Output $NewNComputerName
}

}

Function Add-Computer
{

    Add-Computer -credential (get-credential) -DomainName $CompanyDomain -ComputerName $env:computername -NewName $NewComputerName -OUPath $CompanyOU -PassThru -Restart
}

Get-computername | Add-Computer