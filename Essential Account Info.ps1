$name = Read-Host -Prompt "Please type the username"

get-aduser $name -properties * | Select-Object -Property accountexpirationdate,lockedout,passwordexpired,passwordlastset,whencreated

