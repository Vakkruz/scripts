Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "Bulk Group Remover Script Initiated!" -ForegroundColor DarkRed -BackgroundColor Gray
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
Write-Host ""
Start-Sleep -Seconds 2

#Warning section - Meant to slow the user down and give them time to read and consider
Write-Host "========================== WARNING =========================="-ForegroundColor Yellow -BackgroundColor Black
Write-Host "	This script is very powerful."-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "Excercise extreme caution when using"-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "	as you can accidentally adjust the wrong accounts"-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host "if the targets are not correct!!"-ForegroundColor Yellow -BackgroundColor Black
Write-Host "========================== WARNING =========================="-ForegroundColor Yellow -BackgroundColor Black
Start-Sleep -Seconds 2
Write-Host ""
Write-Host ""


#OU Search Section - Prompts the user to type in OU name to pull user accounts. Structured as a While Loop to give the user multiple chances to type in name in case they get it wrong (PS is very picky about names!)
while ($true){

	Write-Host "STEP 1: Search for which OU you'd like to target"-ForegroundColor DarkRed -BackgroundColor Gray
	Write-Host "	NOTE: OU name needs to be exact and specific (Ex: 23 Boys)"-ForegroundColor DarkRed -BackgroundColor Gray
	$query = Read-Host "Enter here "
	Write-Host ""
	
	Write-Host "Searching..."-ForegroundColor DarkRed -BackgroundColor Gray
	Start-Sleep -Seconds 1
	
	Write-Host "OU found. Please look at it below..." -ForegroundColor DarkRed -BackgroundColor Gray
	Start-Sleep -Seconds 1
	
	#Shows the OU name and distinguised name to the console. User responds if it's good or not
	Get-ADOrganizationalUnit -Filter 'Name -like $query' | Format-Table Name, DistinguishedName -A
	
	Start-Sleep -Seconds 1.5
	Write-Host "Does this look correct to you? Enter Y to proceed or N to search again" -ForegroundColor DarkRed -BackgroundColor Gray
	$continue = Read-Host "Enter here "
	
	
	if ($continue -eq "Y"){
		
		#$dir variable stores directory path in AD to pull all the $Users
		#$Users variable gets all details about users that don't have an underscore in their name. Underscore is only used for Template accounts which we don't want to touch!
		$dir = Get-ADOrganizationalUnit -Filter 'Name -like $query' | Select-Object -ExpandProperty DistinguishedName
		$Users = get-aduser -filter 'Name -notlike "_*"' -searchbase "$dir" | Sort-Object Name #Once we've gotten the users, sort them based on name like in the AD
		
		Write-Host ""
		Write-Host "Thank you. Proceeding to removal stage..."-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
		break #If Y, kill the loop
	}
	elseif($continue -eq "N"){
		Write-Host ""
		Write-Host "Ok. Beginning search again..."-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
		Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
	}
	
}

#Group Search section: Same as before, but for searching group
while ($true){
	
	Write-Host "STEP 2: Please specify A SINGLE group you'd like to remove from accounts."-ForegroundColor DarkRed -BackgroundColor Gray
	$gQuery = Read-Host "Enter here: " 
	Write-Host ""
	Write-Host ""
	
	Write-Host "Searching..."-ForegroundColor DarkRed -BackgroundColor Gray
	Start-Sleep -Seconds 1
	
	Write-Host "Group found. Please look at it below..." -ForegroundColor DarkRed -BackgroundColor Gray
	Start-Sleep -Seconds 1
	
	Get-ADGroup -Filter 'Name -like $gQuery' | Format-Table Name, DistinguishedName -A
	
	Start-Sleep -Seconds 1.5
	Write-Host "Does this look correct to you? Enter Y to proceed or N to search again" -ForegroundColor DarkRed -BackgroundColor Gray
	$continue = Read-Host "Enter here "
	
	if ($continue -eq "Y"){
		
		#targetGroup is the directory path of group
		$targetGroup = Get-ADGroup -Filter 'Name -like $gQuery' | Select-Object -ExpandProperty DistinguishedName
		$targetGroupName = Get-ADGroup -Filter 'Name -like $gQuery' | Select-Object -ExpandProperty Name
		#targetGroupName is the name of the group. Useful for displaying back to user in prompts
		
		Write-Host ""
		Write-Host "Thank you. Proceeding to removal stage..."-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
		break
	}
	elseif($continue -eq "N"){
		Write-Host ""
		Write-Host "Ok. Beginning search again..."-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
		Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
		Write-Host ""
	}
	
}


Write-Host "The following accounts will have changes applied"-ForegroundColor DarkRed -BackgroundColor Gray

#Shows all the Users below
$Users | Format-Table Name

Write-Host "Does this look correct to you? Enter Y to proceed or N to quit" -ForegroundColor DarkRed -BackgroundColor Gray
$continue2 = Read-Host "Enter here "
Write-Host "////////////////////////////////////////////////"-ForegroundColor DarkRed -BackgroundColor Gray
	
if ($continue2 -eq "Y"){
	foreach ($User in $Users) {
		
		# Retrieve UPN
		$UPN = $User.UserPrincipalName

		# Retrieve UPN related SamAccountName
		$ADUser = Get-ADUser -Filter "UserPrincipalName -eq '$UPN'" | Select-Object SamAccountName
		
		# User from CSV not in AD
		if ($ADUser -eq $null) {
			Write-Host "$UPN does not exist in AD" -ForegroundColor Red -BackgroundColor Black
		}
		
		else {
				# Retrieve AD user group membership
				$Membership = (Get-ADUser $user -Properties memberOf).memberOf 
				
				# User is a member of group
				if ($targetGroup -in $Membership) {
					Remove-ADGroupMember -Identity $targetGroup -Members $ADUser.SamAccountName -Confirm:$false 
					Write-Host "Removed $UPN from $targetGroupName" -ForegroundColor White -BackgroundColor DarkGreen
					
				}
				# User is not a member of group
				else {
					Write-Host "$UPN does not exist in $targetGroupName" -ForegroundColor Red -BackgroundColor Black
				
				}
				
			}
		
		}
		
	Write-Host ""
	Write-Host ""
	Write-Host "PROGRAM COMPLETE. Please check for any RED errors. Goodbye!"-ForegroundColor DarkRed -BackgroundColor Gray
	
	}	
else{
	Write-Host ""
	Write-Host ""
	Write-Host "Quitting program. Goodbye!"-ForegroundColor DarkRed -BackgroundColor Gray
}
