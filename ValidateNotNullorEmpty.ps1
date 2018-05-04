
$Name = read-host -Prompt "Name" 
function Get-UserName
{
    [CmdletBinding()]
    param
    (
        [parameter(ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [string]$Name    
    )
      
  
   
}
Get-UserName -Name $null
Get-UserName -name ''
