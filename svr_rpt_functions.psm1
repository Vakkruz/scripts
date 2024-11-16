#===== Functions for Report Script =======

function Get-ServerFile { #Retrieves filename of report
    $date = Get-Date -Format "yyyy.MM.dd"
    Get-ChildItem -Path "./*$date.txt" -Name
}

function Write-ServerFile($output){ #Main function to write to the txt file. Takes one parameter: the thing to be written
    $filename = Get-ServerFile
    $output | Out-File -FilePath .\$filename -Append 
}

function Initialize-ServerFile { #Creates file to be used for writing report
    $date = Get-Date -Format "yyyy.MM.dd" #All reports will have the date as the suffix to make unique, in case there are multiple old reports in directory
    Out-File -FilePath .\ServerStatus-$date.txt
    Write-ServerFile("Hello asshole")
}