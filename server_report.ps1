Import-Module .\svr_rpt_functions.psm1

Write-Host "//////////////////////////////////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "        SERVER STATUS AND ERROR LOG SCRIPT v1.1.6 Initiated!" -ForegroundColor Magenta -BackgroundColor Black
Write-Host "//////////////////////////////////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host ""

Write-Host "////////////////////////////////////////////////"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "Specify the hostnames of servers you'd like reports for"-ForegroundColor Magenta -BackgroundColor Black
Write-Host "	NOTE: For multiple servers, use commas with no leading spaces (Ex: Hostname1,Hostname2,...)"-ForegroundColor White -BackgroundColor Black
$allServers = Read-Host "Enter here" 
Write-Host ""

#Splits the groups based on the commas so the for loop later can read it
$splitServers = $allServers -split ',' 

Write-Host $splitServers -ForegroundColor Yellow -BackgroundColor Black
Write-Host "Does this look correct to you? Enter Y to proceed to account creation or N to quit" -ForegroundColor Magenta -BackgroundColor Black
$continue = Read-Host "Enter here"
if($continue -eq "Y"){

    Write-Host "Beginning Server Status File..." -ForegroundColor Magenta -BackgroundColor Black
    Start-Sleep -Seconds 2
    Initialize-ServerFile
    $filename = Get-ServerFile

    foreach ($Server in $splitServers){
        if ($Server -eq ""){#If the server list has a blank entry, skip it to prevent a crash
            Write-Host "=== BLANK ENTRY DETECTED. SKIPPING... ===" -ForegroundColor Red -BackgroundColor Black
        }else{
            Write-Host "PROCESSING $Server STATUS...Please wait..." -ForegroundColor Magenta -BackgroundColor Black
            Write-ServerFile("=============$Server=============$Server=============$Server=============")
            Write-ServerFile("")
            Write-Memory($Server)
            Write-CPULoad($Server)
            Write-Storage($Server)
        }

    }
    Write-Host "Status File Complete! Look for $filename in the current directory!" -ForegroundColor Green -BackgroundColor Black
    Start-Sleep -Seconds 1
    Write-Host "Now begining Log File Generation. Please wait..." -ForegroundColor Magenta -BackgroundColor Black
    Initialize-LogFile 
    $filename2 = Get-LogFilename
    Start-Sleep -Seconds 1

    foreach ($Server in $splitServers){
        if ($Server -eq ""){#If the server list has a blank entry, skip it to prevent a crash
            Write-Host "=== BLANK ENTRY DETECTED. SKIPPING... ===" -ForegroundColor Red -BackgroundColor Black
        }else{
            Write-Host "WRITING $Server ERROR LOGS...Please wait..." -ForegroundColor Magenta -BackgroundColor Black
            Write-LogFile("=============$Server=============$Server=============$Server=============")
            Write-LogFile("")
            Write-LogQuery($Server)
        }
    }
    Write-Host "Log File Complete! Look for $filename2 in the current directory!" -ForegroundColor Green -BackgroundColor Black
    Start-Sleep -Seconds 1
    Write-Host "The program is finished. If there were any errors, double-check the server itself. Sometimes there are communication issues." -ForegroundColor Magenta -BackgroundColor Black
    Write-Host "Additionally, if you'd like to run this program again quit Powershell then open it again" -ForegroundColor Magenta -BackgroundColor Black
    Write-Host ""
    Start-Sleep -Seconds 4
    Write-Host "TERMINATING...." -ForegroundColor Yellow -BackgroundColor Black
}else{
    Write-Host "TERMINATING...." -ForegroundColor Yellow -BackgroundColor Black
}