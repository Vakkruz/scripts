#===== Functions for Report Script =======

function Get-TimeofDay{ #Generates date suffix to be used for regex in other functions
    Get-Date -Format "yyyy.MM.dd"
}

function Get-ServerFile { #Retrieves filename of report based on the current date
    $date = Get-TimeofDay
    Get-ChildItem -Path "./*$date.txt" -Name
}

function Write-ServerFile($output){ #Main function to write to the txt file. Takes one parameter: the thing to be written
    $filename = Get-ServerFile
    $output | Out-File -FilePath .\$filename -Append 
}

function Initialize-ServerFile { #Creates file to be used for writing report
    
    if (Get-ServerFile -ne $null){#If file already exists, overwrite
        $date = Get-TimeofDay #All reports will have the date as the suffix to make unique, in case there are multiple old reports in directory
        $filename = Get-ServerFile
        $output | Out-File -FilePath .\$filename
        Write-ServerFile("SERVER STATUS REPORT--GENERATED $date")
    }else{
        $date = Get-TimeofDay 
        Out-File -FilePath .\ServerStatus-$date.txt
        Write-ServerFile("SERVER STATUS REPORT--GENERATED $date")
    }
    
}

function Write-Memory($hostname){
    Write-ServerFile(Get-Counter -Counter "\memory\available mbytes" -computername $hostname)
    Write-ServerFile("")
}

function Write-CPULoad($hostname){
    Write-ServerFile(Get-WmiObject win32_processor -computername $hostname | Measure-Object -property LoadPercentage -Average | Select Average)
    Write-ServerFile("")
}

function Write-Storage($hostname){
    Write-ServerFile(Get-WmiObject -Class Win32_LogicalDisk -ComputerName $hostname | ? {$_. DriveType -eq 3} | select DeviceID, {$_.Size /1GB}, {$_.FreeSpace /1GB})
}