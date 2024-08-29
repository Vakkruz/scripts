
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "Account Creation Script Initiated!" -ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host ""

Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "STEP 1: Please specify the name of CSV you'd like to import."-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "	NOTE: It must be in the same folder as script and have .csv appended (Ex. filename.csv)"-ForegroundColor Gray -BackgroundColor Black
$filename = Read-Host "Enter here: "
Write-Host ""
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray

Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "STEP 2: Please specify groups you'd like to add new accounts to."-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "	NOTE: For multiple groups, use commas with no leading spaces (Ex: Group A,Group B,Group D,...)"-ForegroundColor Gray -BackgroundColor Black
$allGroups = Read-Host "Enter here: " 
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host ""

$splitGroups = $allGroups -split ',' #Splits the groups based on the commas so the for loop later can read it

Write-Host "The CSV File has been imported. Please look at it below..." -ForegroundColor DarkRed -BackgroundColor Gray
Start-Sleep -Seconds 1

Import-Csv ".\$filename" | Format-Table

Start-Sleep -Seconds 1.5
Write-Host "Does this look correct to you? Enter Y to proceed to account creation or N to quit" -ForegroundColor DarkRed -BackgroundColor Gray
$continue = Read-Host "Enter here:"

if ($continue -eq "Y"){
	Write-Host "Thank you. Proceeding to account creation..."-ForegroundColor DarkRed -BackgroundColor Gray
	Write-Host ""
	$Users = Import-Csv ".\$filename"
	foreach ($User in $Users) {
		# Retrieve UPN
		$UPN = $User.UserPrincipalName

		# Retrieve UPN related SamAccountName
		$ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName
		
		#If the user does not exist in AD, create the account and add them to group
		if($ADUser -eq $null){
			Write-Host "$UPN does not exist in AD. Creating account..." -ForegroundColor White -BackgroundColor DarkGreen
			$User | New-ADUser -Enabled $True -AccountPassword (ConvertTo-SecureString Monday16 -AsPlainText -force) #Creates account with boilerplate password
			$ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName
			
			#Once the account is created, add them to all groups specified at the start
			if($ADUser -ne $null){
				Write-Host "$UPN account created. Adding to groups now..." -ForegroundColor White -BackgroundColor DarkGreen
				foreach($Group in $splitGroups){
					# Add user to group
					Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName
					Write-Host "Added $UPN to $Group" -ForegroundColor White -BackgroundColor DarkGreen
				}
			}
			
			#Writes an empty line to the console for easier readability
			Write-Host ""
		}
		
		#If the username specified in the CSV is not unique, it will throw this error. Go back to the sheet and revise, or do a manual creation.
		else{
			Write-Host "$UPN is not a unique name. Please change and try again" -ForegroundColor Red -BackgroundColor Black
			Write-Host ""
		}
		
	}
}else{
	Write-Host "Quitting program. Goodbye!..." -ForegroundColor DarkRed -BackgroundColor Gray
}

<#

#>