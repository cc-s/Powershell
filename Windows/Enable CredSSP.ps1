#Run on local machine
Enable-WSManCredSSP -Role Client -DelegateComputer *.domain.local -Force
#Run on first hop server
Enable-WSMaCredSSP -Role Server –Force
#To use CredSSP, Run from local machine
$session = New-PSSession -ComputerName server1.domain.local -Credential $credential -Authentication Credssp
#OR
Enter-PSSession -ComputerName server1.domain.local -Credential $credential -Authentication Credssp 
