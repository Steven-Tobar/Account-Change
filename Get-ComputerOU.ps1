
 <#
 .Synopsis
    Gets the computer's OU
 .DESCRIPTION
    A tech can quickly check if the computer is in the proper OU with this function.
 .EXAMPLE
    Get-ComputerOU localhost
 #>
 function Get-ComputerOU
 {
     [CmdletBinding()]
     Param
     (
         # The name of the computer is mandatory.
         [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
         $ComputerName

     )
 
     Begin
     {
     }
     Process
     {
       Get-ADComputer $ComputerName -Properties * | select canonicalname | fl
     }
     End
     {
        
     }
 }

