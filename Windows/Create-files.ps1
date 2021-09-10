#Create-files
function New-Files {
     <#
.Synopsis
   Creates files based on requested size
.DESCRIPTION
   Long description
.EXAMPLE
   
.EXAMPLE
   
.EXAMPLE
 
.ROLE
   The role this cmdlet belongs to
.FUNCTIONALITY
   The functionality that best describes this cmdlet
#>
     [CmdletBinding(DefaultParameterSetName = 'File')]
     [Alias()]
     Param
     (
          # File Size with unit
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 0,
               ParameterSetName = 'File')]
          $FileSize,
          
          # Number of files to create
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 1,
               ParameterSetName = 'File')]
          [int]$NumberOfFiles,

          # Directory path to where the files will be created
          [Parameter(Mandatory = $true,
               ValueFromPipelineByPropertyName = $true,
               Position = 2,
               ParameterSetName = 'File')]
          [ValidateScript( {
                    if ( -Not ($_ | Test-Path) ) {
                         throw "Folder does not exist"
                    }
                    return $true
               })]
          [System.IO.FileInfo]$Path,

          [Parameter(Mandatory = $false,
               ValueFromPipelineByPropertyName = $true,
               Position = 3,
               ParameterSetName = 'File')]
               $NumberOfDirs
     )

     Begin {
          $i = 0
     }
     Process {

          switch ($NumberOfDirs) {
               "$null" { 
                    while ($i -lt $NumberOfFiles) {
                         $ByteObj = New-Object -TypeName Byte[] -ArgumentList ($FileSize / 4.58 )
                         $RandomObj = New-Object -TypeName System.Random 
                         $RandomObj.NextBytes($ByteObj)
          
                         Set-Content -Path "$path\testfiles$i" -Value $ByteObj -Encoding utf8
                         $i++
                    }#end while
               }#End Null
               "0" {break}
               Default {
                    $array = 0..$NumberOfFiles
                    $j = 1
                    $k = 1
                         do {
                         $NewPath = "$($path)folder$k"
                              mkdir $NewPath
                         
                         $j..(($j+= $NumberOfDirs) - 1) | ForEach-Object {
                              
                           #   while ($i -lt $NumberOfFiles) {
                                   $ByteObj = New-Object -TypeName Byte[] -ArgumentList ($FileSize / 4.58 )
                                   $RandomObj = New-Object -TypeName System.Random 
                                   $RandomObj.NextBytes($ByteObj)
                    
                                   Set-Content -Path "$NewPath\testfiles$_" -Value $ByteObj -Encoding utf8
                             #      $i++
                            #  }#end while
                         }#end foreach file
                         if ($k -lt $NumberOfDirs)
                         {$k++}
                         }
                         until ($j -ge $array.count -1)
               }#End Default
          }#End switch
     }#end process
     End {}

}#End functions New-Files



New-Files -Path "./" -FileSize 4kb -NumberOfFiles 8 -NumberOfDirs 2