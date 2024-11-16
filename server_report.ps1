Import-Module .\svr_rpt_functions.psm1


Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Black
Write-Host "        SERVER STATUS SCRIPT Initiated!" -ForegroundColor DarkRed -BackgroundColor Black
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Black
Write-Host ""

Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Black
Write-Host "Specify the hostnames of servers you'd like reports for"-ForegroundColor DarkRed -BackgroundColor Black
Write-Host "	NOTE: For multiple groups, use commas with no leading spaces (Ex: Group A,Group B,Group D,...)"-ForegroundColor White -BackgroundColor Black
$allServers = Read-Host "Enter here " 

$splitServers = $allServers -split ',' #Splits the groups based on the commas so the for loop later can read it

Write-Host $splitServers
Write-Host "Does this look correct to you? Enter Y to proceed to account creation or N to quit" -ForegroundColor DarkRed -BackgroundColor Black
$continue = Read-Host "Enter here"
if($continue -eq "Y"){

    Initialize-ServerFile

    foreach ($Server in $splitServers){
        Write-ServerFile("=============$Server=============")
        Write-ServerFile("")
        Write-Memory($Server)
        Write-CPULoad($Server)
        Write-Storage($Server)
    }
}else{
    Write-Host "Program Terminated!"
}

Write-Host "Program Complete! Look for the filename below in the current directory!"