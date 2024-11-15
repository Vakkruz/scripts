function Initialize-ServerFile {
    $timeofday = Get-Date -Format "yyyy.MM.dd"
    Out-File -FilePath .\ServerStatus-$timeofday.txt
}