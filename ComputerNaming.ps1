
Function Get-ComputerName
{

    $Location = Read-Host -Prompt "Please enter 'T' for Trade and 'L' for Learning"

if ($Location -eq "T")
{
    $FIBTemplate = "TRLUSNYFIB-"
   
    #starting at 1000 for the computer names since it's at like 1040 right now. It'll give us a buffer before we think of a better way of doing this
    $FIB = Get-ADComputer -filter 'Name -like "TRLUSNYFIB-1*"' -SearchBase "OU=Laptops,OU=_Machines,DC=newyork,DC=hbpub,DC=net" | select name | sort name
    
    $LastComputerFIB = $FIB[-1].name
    
    [int]$DigitsFIB = $LastComputerFIB.substring($LastComputerFIB.lastindexof("-")+1)
    #Takes the last 4 digits of the computer name from the last computer in FIB with the name TRLUSNYFIB-1XXX and spits out the digits "1XXX". 
    
    $DigitsFIB += 1

    $NewFIBComputerName = -join($FIBTemplate,$DigitsFIB)
    
    Write-Output $NewFIBComputerName    
}
elseif($Location -eq "L")
{
    $NYPTemplate = "TRLUSNYNYP-"
    
    $NYP = Get-ADComputer -filter 'Name -like "TRLUSNYNYP-0*"' -SearchBase "OU=Laptops,OU=_Machines,DC=newyork,DC=hbpub,DC=net" | select name | sort name
    
    $LastComputerNYP = $NYP[-1].name
    
    [int]$DigitsNYP = $LastComputerNYP.substring($LastComputerNYP.lastindexof("-")+1)
    #Takes the last 4 digits of the computer name from the last computer in FIB with the name TRLUSNYFIB-1XXX and spits out the digits "1XXX". 
    
    $DigitsNYP += 1

    $NewNYPComputerName = -join($NYPTemplate,$DigitsNYP)

    Write-Output $NewNYPComputerName
}

}

Function Add-Computer
{
    
    Add-Computer -credential (get-credential) -DomainName NewYork.HBPub.net -ComputerName $env:computername -NewName $NewComputerName -OUPath "OU=Laptops,OU=_Machines,DC=newyork,DC=hbpub,DC=net" -PassThru -Restart
}

Get-computername | Add-Computer