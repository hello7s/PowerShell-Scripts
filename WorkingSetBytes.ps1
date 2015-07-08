$explorer_monitor = "\Process(explorer)\Working Set - Private" | select -ExpandProperty countersamples | select cookedvalue
<# if ($explorer_monitor > 3000000)
{ Stop-Process explorer*
  Start-Process "explorer.exe"
}
else
{
 Write-Host "No Trojan Yet!"
}
#>