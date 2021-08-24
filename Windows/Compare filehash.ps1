#Compare filehash
Function Compare-FileHashes {
     <#
.Synopsis
   Compares a set of SHA265 hashes to one or more files.
.DESCRIPTION
   Long description
.EXAMPLE
   Compare-FileHashes -Hashlist "9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E" -Files "E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"
.EXAMPLE
   "9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E" | Compare-FileHashes -Files "E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"
.EXAMPLE
 $a = [PSCustomObject]@{"Hashlist"="9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2", "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E"; "Files"="E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi","E:\Users\Carl C\Downloads\mumble-1.2.4.msi"}
 $a | Compare-FileHashes
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
     [CmdletBinding(DefaultParameterSetName = 'File')]
     [Alias()]
     Param
     (
          # Hashes in an array
          [Parameter(Mandatory = $true,
               ValueFromPipeline = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0)]
          [string[]]$Hashlist,
 
          # File paths
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'File')]
          $Files,
          
          # Dir path
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'Directory')]
          $Directory
     )

     #$Hashlist = "9190F005ADCC59F1D2CFF21B8D4FBBA70D72B8B4B567D845B33508A9C388A7A2",  "E83D5041B91BC337092E5BA54DFFD9B90AF2DA3ACA365D700458059B7F5C184E"
     #$Files = "E:\Users\Carl C\Downloads\PowerShell-7.1.4-win-x64.msi"
     #$algorithm = "sha256"

     Begin {
          $obj = @()

          #$Files = dir "C:\Users\Downloads\" -File | ? Name -Like "*msi*"
          
          switch ($PSCmdlet.ParameterSetName) {
               'File' {
                    try {
                         if ( $($Files[0].GetType()).BaseType -eq [System.IO.FileSystemInfo]) {
                              $Files = $files.FullName
                         } # Check fileobject type
                    }
                    catch [System.Exception] {
                         # Exception is stored in the automatic variable _
                         
                    }
               }
               'Directory' {
                    try {
                         $Dir = dir $Directory -File -ErrorAction Stop
                    }
                    catch [System.Exception] {
                         # Exception is stored in the automatic variable _
                         Write-Error "That was not a directory path!!"
                    }
                    $files = $Dir.FullName
               }
          }# end Switch

          if ($Files.Count -gt 16) {
               Write-Warning "There are more than 16 files will abort. Use File parameter instead and pick fewer files"
               break
          }

     } #end Begin

     Process {
          foreach ($file in $Files) {

               $FilHash = get-filehash -path $file -Algorithm $algorithm

               foreach ($Hash in $Hashlist) {

                    if ($FilHash.hash -eq "$Hash") {
                         $state = @{"State" = "OK"; "Path" = $FilHash.path }


                    }#end if has eq
                    else {
                         Continue
                    }
                    $obj += New-Object -TypeName psobject -Property $state
               }#End forach hashlist

          }# End foreach file
     }#end process
     End {
          if ($obj -eq $null) {
               Write-Host "No equal hash was found"
          }
          else {
               $obj
          }
     }#End
}#End function Compare-FileHashes