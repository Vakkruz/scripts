
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "Password Change Script Initiated!" -ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host ""
Start-Sleep -Seconds 2

Write-Host "========================== WARNING =========================="-ForegroundColor Yellow -BackgroundColor Black
Write-Host "	This script is very powerful."-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "Excercise extreme caution when using"-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "	as you can accidentally change passwords "-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "if the accounts are not correct!!"-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "========================== WARNING =========================="-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host ""
Write-Host ""

Write-Host "STEP 1: Please specify the name of CSV you'd like to import."-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "	NOTE: It must be in the same folder as script and have .csv appended (Ex. filename.csv)"-ForegroundColor DarkRed -BackgroundColor Gray
$filename = Read-Host "Enter here: "
Write-Host ""

Write-Host "The CSV File has been imported. Please look at it below..." -ForegroundColor DarkRed -BackgroundColor Gray
Start-Sleep -Seconds 1

Import-Csv ".\$filename" | Format-Table

Start-Sleep -Seconds 1.5
Write-Host "Does this look correct to you? If so, type Y to proceed. If not, type N to quit" -ForegroundColor DarkRed -BackgroundColor Gray
$continue = Read-Host "Enter here: "

if ($continue -eq "Y"){
	Write-Host "Thank you. Proceeding..."-ForegroundColor DarkRed -BackgroundColor Gray
	Write-Host ""
	$Users = Import-Csv ".\$filename"
	foreach ($User in $Users) {
		# Retrieve SAM
		$SAM = $User.SamAccountName
		
		$Pass = $User.Password

		# Retrieve UPN related SamAccountName
		$ADUser = Get-ADUser -Filter "SamAccountName -eq '$SAM'" | Select-Object SamAccountName

		# User from CSV not in AD
		if ($ADUser -eq $null) {
			Write-Host "$SAM does not exist in AD" -ForegroundColor Red -BackgroundColor Black
		}else {
			Set-ADAccountPassword -Identity $SAM -NewPassword (ConvertTo-SecureString -String $Pass -AsPlainText -Force)
			Write-Host "$SAM's passsword is set" -ForegroundColor White -BackgroundColor DarkGreen
		}
	}
	
	Write-Host ""
	Start-Sleep -Seconds 1
	Write-Host "Complete.." -ForegroundColor DarkRed -BackgroundColor Gray
	Write-Host ""
	Start-Sleep -Seconds 2
	
	Write-Host "For safety precautions, the CSV file is automatically deleted."-ForegroundColor Yellow -BackgroundColor Black
	Start-Sleep -Seconds 3
	Write-Host "Deleting $filename now..."-ForegroundColor Yellow -BackgroundColor Black
	Remove-Item ".\$filename"
	Start-Sleep -Seconds 2
	Write-Host "Complete....."-ForegroundColor Yellow -BackgroundColor Black
	Start-Sleep -Seconds 2
	
	
	Write-Host ""
	Write-Host ""
	Write-Host "END OF PROGRAM" -ForegroundColor DarkRed -BackgroundColor Gray
	
}else{
	Write-Host "Quitting program. Goodbye!" -ForegroundColor DarkRed -BackgroundColor Gray
}




