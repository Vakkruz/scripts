#===== Functions for Report Script =======

function Initialize-ServerFile { #Creates file to be used for writing report
    $date = Get-Date -Format "yyyy.MM.dd" #All reports will have the date as the suffix to make unique, in case there are multiple old reports in directory
    Out-File -FilePath .\ServerStatus-$date.txt
}
function Get-ServerFile { #Retrieves filename of report
    $date = Get-Date -Format "yyyy.MM.dd"
    Get-ChildItem -Path "./*$date.txt" -Name
}

function Write-ServerFile{
    $filename = Get-ServerFile
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 

    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 

    Get-Date -Format "yyyy.MM.dd HH:mm:ss.ffff" | Out-File -FilePath .\$filename -Append 
}