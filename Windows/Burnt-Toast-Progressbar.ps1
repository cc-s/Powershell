$Files = Get-ChildItem "C:\Windows\System32"

#Create the initial toast message
$Status = "Copying files"
$Text = "Something is happening"
$id = "msg001"
#Argument opens a file
$ToastHeader = New-BTHeader -Id $id -Title "Toast title (click)" -Arguments "C:\temp\log.log"
$Progress = New-BTProgressBar -Status $Status -Indeterminate

New-BurntToastNotification -Text $Text `
     -ProgressBar $Progress -Header $ToastHeader -UniqueIdentifier $id

# Calculate a 25% update interval
[int]$Interval = ($Files.count) * 0.25

#Counter to determine progress update
$i = 1

foreach ($File in $Files) {
     $i += 1
     if ($i -eq $Interval -or $i -eq $($Interval * 2) -or $i -eq $($Interval * 3) -or $i -eq $($Interval * 4)) {
          $per = [Math]::Round($i / ($Files.count), 2)
          $Progress = New-BTProgressBar -Status $Status -Value $per
          New-BurntToastNotification -Text $Text `
               -ProgressBar $Progress -Header $ToastHeader -UniqueIdentifier $id
     }#End if

     #What to do
     Start-Sleep -Milliseconds 10
}#End foreach File