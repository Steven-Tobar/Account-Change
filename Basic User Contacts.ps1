cls

$user = Read-Host -Prompt "Please enter a username"

get-aduser $user -Properties * | select Name, Officephone, Mail,Manager | fl



 