#===== Function 

function Initialize-ServerFile {
    $date = Get-Date -Format "yyyy.MM.dd"
    Out-File -FilePath .\ServerStatus-$date.txt
}
function Get-ServerFile {
    $date = Get-Date -Format "yyyy.MM.dd"
    Get-ChildItem -Path "./*$date.txt" -Name
}

