Function Show-Progressbar {
     Param (
          [parameter(Mandatory)]
          [scriptblock]$Command,
          [parameter(Mandatory, ValueFromPipeline)]
          $Array
     )

     Begin {
          
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
          [int]$Interval = ($Array.count) * 0.25

          #Counter to determine progress update
          $i = 1

     }#end begin

     Process {
          
          foreach ($Object in $Array) {
               $i += 1
               if ($i -eq $Interval -or $i -eq $($Interval * 2) -or $i -eq $($Interval * 3) -or $i -eq $($Interval * 4)) {
                    $per = [Math]::Round($i / ($Array.count), 2)
                    $Progress = New-BTProgressBar -Status $Status -Value $per
                    New-BurntToastNotification -Text $Text `
                         -ProgressBar $Progress -Header $ToastHeader -UniqueIdentifier $id
               }#End if

               #What to do
               $Command.InvokeReturnAsIs()

          }#End foreach File
     }#End Process

     End {}#End end
}#End function Show-Progressbar

$Files | Show-Progressbar -Command { $_.fullname; Start-Sleep -Milliseconds 10 }