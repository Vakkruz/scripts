#===== Functions for Report Script =======

$ErrorActionPreference = 'Stop' #Any error generated 'stops' the script, allowing the use of Try-Catch 

function Get-TodaysDate{ #Generates date suffix to be used for regex in other functions
    Get-Date -Format "yyyy.MM.dd"
}

function Get-MonthAgo{
    (Get-Date).AddMonths(-1)
}

function Get-ServerFile { #Retrieves filename of report based on the current date
    $date = Get-TodaysDate
    Get-ChildItem -Path "./*$date.txt" -Name
}

function Write-ServerFile($output){ #Main function to write to the txt file. Takes one parameter: the thing to be written
    $filename = Get-ServerFile
    $output | Out-File -FilePath .\$filename -Append 
}

function Write-Memory($hostname){
    try{
        Write-ServerFile(Get-Counter -Counter "\memory\available mbytes" -computername $hostname) 
    }catch{
        Write-Host ">>>> Powershell detected an error with Hostname: $hostname. Will not write to file. Check spelling or connect directly to server." -ForegroundColor Red -BackgroundColor Black
    }finally{
        Write-ServerFile("")
    }
}

function Write-CPULoad($hostname){
    try {
        Write-ServerFile(Get-WmiObject win32_processor -computername $hostname | Measure-Object -property LoadPercentage -Average | Select Average)
    }
    catch {
        Write-Host ">>>> Powershell detected an error with Hostname: $hostname. Will not write to file. Check spelling or connect directly to server." -ForegroundColor Red -BackgroundColor Black
    }
    finally {
        Write-ServerFile("")
    }
}

function Write-Storage($hostname){
    try {
        Write-ServerFile(Get-WmiObject -Class Win32_LogicalDisk -ComputerName $hostname | ? {$_. DriveType -eq 3} | select DeviceID, {$_.Size /1GB}, {$_.FreeSpace /1GB})
    }
    catch {
        Write-Host ">>>> Powershell detected an error with Hostname: $hostname. Will not write to file. Check spelling or connect directly to server." -ForegroundColor Red -BackgroundColor Black
    }
    finally {
        Write-ServerFile("")
    }


    
}


