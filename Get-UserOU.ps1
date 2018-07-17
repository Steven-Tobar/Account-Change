<#
.Synopsis
   Gets the user OUs.

.DESCRIPTION
   Allows the tech to find if a user needs to be added to an OU for access to an application or security group.

.EXAMPLE
   Get-UserOU steven.tobar
#>
function Get-UserOU
{
    [CmdletBinding()]
    Param
    (
        #Username is mandatory.
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $UserName
    )

    Begin
    {
    }
    Process
    {
        Get-ADPrincipalGroupMembership $UserName | select name
    }
    End
    {
    }
}

Get-UserOU steven.tobar
