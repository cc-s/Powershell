function New-Names {
     [CmdletBinding()]
     param (
          [Parameter(
               Mandatory = $true
          )]
          [int]
          $CountNames
     )

     $Names = Invoke-RestMethod -Method Get -Uri "https://api.namnapi.se/v2/names.json?limit=100"

     $NewName = @()

     for ( $i = 0; $i -lt $CountNames; $i++) {
          $FirstName = Get-Random -Maximum $Names.names.firstname 
          $LastName = Get-Random -Maximum $Names.names.surname

          $Props = @{
               Firstname = $FirstName
               Lastname  = $LastName
          }

          $NewName += New-Object -TypeName PSCustomObject -Property $props
     }

     #($NewName | Sort-Object | Get-Unique -AsString).count
     $NewName | Sort-Object | Get-Unique -AsString

}#End New-Names

#New-Names -CountNames 500 -OutVariable names



#Create random passwords
Function New-Password {
     [CmdletBinding()]
     param (
          [Parameter(
               Mandatory = $true
          )]
          [int]$Count,
          [switch]$Secure
     )

     $reg = @"
(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])(.*[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?])
"@
     # ASCI codes in decimal to generate chars
     $SpecialChars = 33..47 + 58..64 #'*','!','@'
     $Numbers = 48..57
     $SmallChars = 65..90
     $LargeChars = 97..122

     $AllChars = @()
     $Numbers + $SmallChars + $LargeChars + $SpecialChars | ForEach-Object { $AllChars += [char]$_ }

     #$SpecialChars | foreach {$AllChars+=$_}

     #Create Password array
     [string]$Pass = @()

     <#    
      for ($i = 1; $i -le $Count; $i++) {
          $Pass += Get-Random -InputObject $AllChars
     }
  #>

     do {
          #If statement needed because complexity check will trigger on empty array.
          if ($pass -eq "") {
               #First Run. Just move on
          }
          else {
               #If Pass not complex clear Pass varable
               if ($pass -notmatch "$reg") {
                    Write-Verbose "$Pass is not complex"
                    Clear-Variable Pass
               }
          }#End else
          for ($i = 1; $i -le $Count; $i++) {
               $Pass += Get-Random -InputObject $AllChars
          }
          #Continue Do loop untill password is complex
     } while ($pass -notmatch "$reg")


     if ($Secure) {
          $Pass | ConvertTo-SecureString -AsPlainText -Force
     }
     else {
          $Pass
     }

}#New password

New-Password -Count 10 -Verbose