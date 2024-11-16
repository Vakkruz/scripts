Import-Module .\svr_rpt_functions.psm1

Write-Host "////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "        SERVER STATUS SCRIPT Initiated!" -ForegroundColor Magenta -BackgroundColor Black
Write-Host "////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host ""

Write-Host "////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "Specify the hostnames of servers you'd like reports for"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "	NOTE: For multiple servers, use commas with no leading spaces (Ex: Hostname1,Hostname2,...)"-ForegroundColor White -BackgroundColor Black
$allServers = Read-Host "Enter here " 

$splitServers = $allServers -split ',' #Splits the groups based on the commas so the for loop later can read it

Write-Host $splitServers
Write-Host "Does this look correct to you? Enter Y to proceed to account creation or N to quit" -ForegroundColor Magenta -BackgroundColor Black
$continue = Read-Host "Enter here"
if($continue -eq "Y"){

    Initialize-ServerFile
    $filename = Get-ServerFile

    foreach ($Server in $splitServers){
        if ($Server -eq ""){#If the server list has a blank entry, skip it to prevent a crash
            Write-Host "=== BLANK ENTRY DETECTED. SKIPPING... ===" -ForegroundColor Red -BackgroundColor Black
        }else{
            Write-Host "PROCESSING $Server...Please wait..." -ForegroundColor Magenta -BackgroundColor Black
            Write-ServerFile("=============$Server=============")
            Write-ServerFile("")
            Write-Memory($Server)
            Write-CPULoad($Server)
            Write-Storage($Server)
        }

    }
    
    Write-Host "Program Complete! Look for $filename in the current directory!"
}else{
    Write-Host "Program Terminated!"
}