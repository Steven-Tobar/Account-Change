<#
.Synopsis
   Gets the user's distribution lists.

.DESCRIPTION
   Allows the tech to see which distribution list a user is apart of.

.EXAMPLE
   Get-UserOU steven.tobar
#>
function Get-UserDistro
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

Get-UserDistro steven.tobar
