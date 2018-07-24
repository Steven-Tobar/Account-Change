$CurrentPrinters = Get-Printer
$NetworkPrinter = "printer path here"
if ($CurrentPrinters.name -eq $UniflowPrinter)
{
    Write-host "The network printer is already installed." -ForegroundColor Yellow

}
else
{
    Add-Printer -ConnectionName $NetworkPrinter
    Write-Host "The printer has been added." -ForegroundColor Yellow

}