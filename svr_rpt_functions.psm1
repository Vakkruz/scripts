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
        $filename = Get-ServerFile
        $output | Out-File -FilePath .\$filename
        Write-ServerFile("Hello asshole again")
    }else{
        $date = Get-TimeofDay #All reports will have the date as the suffix to make unique, in case there are multiple old reports in directory
        Out-File -FilePath .\ServerStatus-$date.txt
        Write-ServerFile("Hello asshole")
    }
    
}