$user  = get-aduser steven.tobar -properties *


$x = $user.PasswordLastSet

if ($x -eq $x.AddDays(+31))
{
   Write-host "Password expiring in 2 weeks" -ForegroundColor Yellow 
} 

elseif ($x -gt $x.AddDays(+38) -and $x -lt $x.AddDays(+45))
{
   Write-host "Password expiring in 1 week" -ForegroundColor Cyan
}

elseif($x -eq $x.AddDays(+42))
{
   Write-Host "Password expiring in 3 days" -ForegroundColor Magenta
}

else
{
   write-host "You good." -ForegroundColor green
}




