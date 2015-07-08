$ID = "IISReset Started at "
$startD = Get-Date
$FormatedDate = (Get-Date).AddDays(0).ToString("MMddyyyy")
$LogName = $startD.Month + $startD.Day + $startD.Year
$ID + $startD + ". Below is the list of apppools before stop command: -" | out-file -Append .\$FormatedDate.txt
function get-apppools{
    [regex]$pattern="-ap ""(.+)"""
    gwmi win32_process -filter 'name="w3wp.exe"' | % {
        $name=$_.name
        $cmd = $pattern.Match($_.commandline).Groups[1].Value
        $procid = $_.ProcessId
        New-Object psobject | Add-Member -MemberType noteproperty -PassThru Name $name |
            Add-Member -MemberType noteproperty -PassThru AppPoolID $cmd |
            Add-Member -MemberType noteproperty -PassThru PID $procid 
    }
}

get-apppools | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-file -Append .\$FormatedDate.txt

"Issuing IIS Stop command....." | out-file -Append .\$FormatedDate.txt

iisreset /stop

sleep 5

"IIS stopped..." | out-file -Append .\$FormatedDate.txt

$Results= get-apppools | Format-Table -Property * -AutoSize | Out-String -Width 4096 | Out-file -Append .\$FormatedDate.txt

if (($Results -ne $Null) -and ($Results -ne "" ) -and ($Results -ne $null))
{
"Below is the list of app pools after stopping IIS.... " | Out-file -Append .\$FormatedDate.txt
$Results | Out-file -Append .\$FormatedDate.txt

}

"Issuing IIS Start command....." | out-file -Append .\$FormatedDate.txt

iisreset /start

$IISEndDate = Get-Date

"IIS start completed at " + $IISEndDate | out-file -Append .\$FormatedDate.txt