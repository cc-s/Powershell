$Files = Get-ChildItem "C:\Windows\System32"

$ToastHeader = New-BTHeader -Id '001' -Title "Toast Rubrik" -Arguments 'http://google.se"'
$Progress = New-BTProgressBar -Status 'Copying files' -Indeterminate


New-BurntToastNotification -Text 'File copy script running', 'Hmm!' `
     -ProgressBar $Progress -Header $ToastHeader -UniqueIdentifier 'msg001'

[int]$Intervall = ($Files.count) * 0.25

$i = 1
foreach ($file in $Files) {
     $i += 1
     #  $Intervall = [Math]::Round($i/$Files.count,1)

     if ($i -eq $Intervall -or $i -eq $($Intervall * 2) -or $i -eq $($Intervall * 3) -or $i -eq $($Intervall * 4)) {
          $per = [Math]::Round($i / ($Files.count), 2)
          $Progress = New-BTProgressBar -Status 'This is not happening' -Value $per
          New-BurntToastNotification -Text "Deleting files", 'Hmm!' `
               -ProgressBar $Progress -Header $ToastHeader -UniqueIdentifier 'msg001'
     }#end if

     Start-Sleep -Milliseconds 10
}