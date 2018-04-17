$user = Read-Host -Prompt "Please enter a username"


get-aduser $user -Properties * | select name, officephone, mail 
 