#
#	Name:  Brett van Gennip
#	Script:	Unlocker.ps1
#
#	Role:  Give helpdesk one touch access to find and unlock accounts
#			So that they don't have the users spell their names in AD.
#			Resulting in quicker and painless unlocks.
#
##########################

$oudn="ou=Users,ou=08 Central,OU=CCAC,DC=accounts,DC=ccac-ont,DC=ca"
import-module ActiveDirectory

if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")){
	for($x=1;$x -gt 0;$x++){
	write-host -foregroundcolor yellow "Scanning..."
	$abc=@{}
	$abc[$x]=search-adaccount -lockedout -searchbase $oudn
	if($abc[$x]){
	
	foreach($s in $abc[$x]){
	write-host "-----------------------------------------------"	
	write-host ""	
	write-host -foregroundcolor red "Name:  " $s.name
	write-host ""
	write-host "LastLogonDate:  " $s.LastLogonDate
	write-host ""
	write-host "PasswordExpired:  " $s.PasswordExpired
	write-host ""
	write-host "PasswordNeverExpires:  " $s.PasswordNeverExpires
	write-host ""
	write-host "-----------------------------------------------"
	
		$s.DistinguishedName | unlock-adaccount -confirm
	
		write-host ""
	}
	
	}else{
		write-host ""
		write-host -foregroundcolor magenta "no locked out users detected..."
	}
	write-host ""
	$i=read-host "press any key to re-scan OR press x to exit"
	if($i -like "x" -or $i -like "X"){
		exit
		}
	start-sleep 1
	cls
	}
}
else{
	write-host -foregroundcolor yellow "You must run this script as Administrator! Shift Right-Click, run-as different user.  Use your $ account."
	read-host
}


