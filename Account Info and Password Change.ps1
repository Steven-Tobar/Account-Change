#Created by Steven Tobar 4/6/18


function Get-UserProperties($properties)
{
    #Get basic user properties that can help the tech find out what's wrong with a user account.
    $global:userproperties = get-aduser $name -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated
    
}
    
function Check-LockState
{  
    Get-UserProperties
    #Takes the user and checks to see if they are locked out of their account; if they are, the tech is prompted to change that.
    if ($userproperties.lockedout -eq $true )
        {
            Unlock-ADAccount $name -Confirm
        }
}

function Check-PasswordState
{
    Get-UserProperties
    #checks to see if the user's password is expired; if true the tech is prompted to give a new password.
    if ($userproperties.passwordexpired -eq $true)
    {
        $newpassword = Read-Host -Prompt "Please enter the new password" -AsSecureString
        Set-ADAccountPassword $name -NewPassword $newpassword        
    }    
}

Clear-Host

Do 
{
    $doesntexist = $false
    $name = Read-Host -Prompt "Please enter a username in the format first.name"
    Try
    {   
       #Calls on all the functions
        Get-UserProperties $name 
        echo $userproperties #prints the user properties
        Check-LockState
        Check-PasswordState
        
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException],[Microsoft.ActiveDirectory.Management.Commands.GetADUser]
     {
        #Catches the exception errors for users that don't exist.If they don't, $doesntexist is set to true which prompts the user to try a valid username.
       
       "This user does not exist."
       $doesntexist = $true
           
     }
}

while ($doesntexist)








